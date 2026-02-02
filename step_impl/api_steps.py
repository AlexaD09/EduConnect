import os
import json
import requests
from getgauge.python import step

BASE_URL = os.getenv("BASE_URL", "").rstrip("/")
_state = {"headers": {}, "body": None, "resp": None, "json": None}

def _url(path: str) -> str:
    if not BASE_URL:
        raise Exception("Falta BASE_URL (lo pasa el servidor desde config.env)")
    if not path.startswith("/"):
        path = "/" + path
    return BASE_URL + path

@step("Limpiar headers")
def clear_headers():
    _state["headers"] = {}

@step("Configurar header {name} con valor {value}")
def set_header(name, value):
    _state["headers"][name] = value

@step("Guardar body json")
def set_body_json(body_text):
    _state["body"] = json.loads(body_text)

@step("Hacer GET a {path}")
def do_get(path):
    r = requests.get(_url(path), headers=_state["headers"], timeout=20)
    _state["resp"] = r
    _state["json"] = None
    try:
        _state["json"] = r.json()
    except Exception:
        pass

@step("Hacer POST a {path} con body")
def do_post(path):
    r = requests.post(_url(path), json=_state["body"], headers=_state["headers"], timeout=20)
    _state["resp"] = r
    _state["json"] = None
    try:
        _state["json"] = r.json()
    except Exception:
        pass

@step("La respuesta debe ser {code}")
def assert_status(code):
    r = _state["resp"]
    if r is None:
        raise Exception("No hay respuesta previa")
    if r.status_code != int(code):
        raise Exception(f"Esperaba {code} pero llegó {r.status_code}. Body={r.text[:300]}")

@step("El json debe tener la clave {key}")
def assert_json_key(key):
    if _state["json"] is None:
        raise Exception("La respuesta no fue JSON")
    if key not in _state["json"]:
        raise Exception(f"Falta clave '{key}' en JSON: {_state['json']}")

@step("Guardar token desde clave {key} como header Authorization")
def save_token_as_auth(key):
    if _state["json"] is None or key not in _state["json"]:
        raise Exception(f"No existe '{key}' en la respuesta JSON para token")
    token = _state["json"][key]
    
    _state["headers"]["Authorization"] = f"Bearer {token}"

@step("El contenido debe ser PDF")
def assert_pdf():
    r = _state["resp"]
    ct = (r.headers.get("Content-Type") or "").lower()
    if "pdf" not in ct:
        raise Exception(f"No parece PDF. Content-Type={ct}")
    if len(r.content) < 200:
        raise Exception("PDF demasiado pequeño / vacío")
