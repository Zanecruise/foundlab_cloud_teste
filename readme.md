# 🚀 Deploy MVP ScoreLab/FoundLab no Google Cloud Run

Este projeto é uma evolução do Hello World: agora temos um endpoint institucional (/score), pronto para simular integração real de produto.

---

## 🆙 Mudanças: do Hello World para MVP ScoreLab

* **Antes:** Endpoint `/` retornava `{ "message": "Deploy funcionando!" }`
* **Agora:** Endpoint `/score` retorna payload institucional:

  ```json
  {
    "score": 742,
    "status": "aprovado",
    "timestamp": "2024-05-22T22:00:00.000Z",
    "message": "Simulação de score para demo institucional"
  }
  ```

* Pronto para demo, integração ou uso por investidor/parceiro.

---

## 🔄 Como alterar rotas, payloads e variáveis

### Alterar a rota

No `app.py`, mude o decorator:

```python
@app.get("/score")  # Altere "/score" para outro endpoint
```

### Alterar o payload

No `app.py`, altere ou adicione campos no dicionário `response`:

```python
response = {
    "score": 800,
    "status": "pendente",
    "timestamp": datetime.utcnow().isoformat() + "Z",
    "message": "Payload customizado para teste"
}
```

### Usar variáveis de ambiente

Se quiser ler variáveis sensíveis (API\_KEY, url, etc):

* Adicione ao Dockerfile:

```dockerfile
ENV API_KEY=chave-exemplo
```

* E no Python:

```python
import os
api_key = os.getenv("API_KEY")
```

Inclua as variáveis no deploy:

```sh
gcloud run deploy hello-world --image $env:IMAGE_URI --region=us-central1 --allow-unauthenticated --set-env-vars API_KEY=chave-exemplo
```

---

## ➕ Dependências adicionais

* FastAPI
* Uvicorn
* Se integrar com API externa, adicione ao `requirements.txt`:

  ```
  requests
  ```

  E use no código:

  ```python
  import requests
  ```

---

## 🔗 Simulação de integração

### Comando curl

```sh
curl https://SUA-URL-CLOUDRUN/score
```

### Script Python

```python
import requests
resp = requests.get("https://SUA-URL-CLOUDRUN/score")
print(resp.json())
```

### Exemplo de consumo por parceiro (mock fintech)

```python
def consultar_score(cliente_id):
    url = "https://SUA-URL-CLOUDRUN/score"
    response = requests.get(url)
    if response.status_code == 200:
        resultado = response.json()
        if resultado["score"] >= 700:
            return "Cliente aprovado"
        else:
            return "Cliente recusado"
    else:
        return "Erro na integração"

print(consultar_score("123456789"))
```

---

## 🔐 Segurança e shutdown

### Como proteger o endpoint (Cloud Run)

**Opção 1: Deixar privado (sem --allow-unauthenticated)**

```sh
gcloud run deploy hello-world --image $env:IMAGE_URI --region=us-central1
```

**Opção 2: Auth básica (token simples)**
No app.py:

```python
from fastapi import Header, HTTPException

@app.get("/score")
def get_score(x_api_key: str = Header(None)):
    if x_api_key != "SUA_CHAVE_SECRETA":
        raise HTTPException(status_code=401, detail="Não autorizado")
    # ...payload normal...
```

No curl:

```sh
curl -H "x-api-key: SUA_CHAVE_SECRETA" https://SUA-URL-CLOUDRUN/score
```

> Nunca suba chave secreta em código público! Use variáveis de ambiente em produção.

### Shutdown (nunca deixe rodando à toa)

Sempre execute:

```sh
./shutdown.sh
# ou
 gcloud run services delete hello-world --platform=managed --region=us-central1 -q
```

---

## ✅ Checklist FoundLab MVP

* [x] Endpoint `/score` com payload realista/documentado
* [x] README explica como mudar rota/payload/variáveis
* [x] Simulação de integração (curl, Python)
* [x] Orientação de segurança e shutdown
* [x] Founder/dev consegue alterar, testar e desligar sem depender de ninguém
