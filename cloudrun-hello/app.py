from fastapi import FastAPI
from datetime import datetime

app = FastAPI()

@app.get("/score")
def get_score():
    response = {
        "score": 742,
        "status": "aprovado",
        "timestamp": datetime.utcnow().isoformat() + "Z",
        "message": "Simulação de score para demo institucional"
    }
    return response
