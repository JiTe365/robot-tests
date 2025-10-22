from __future__ import annotations
from dataclasses import dataclass, field
from pathlib import Path
import json, time, uuid
from robot.api import logger

class DataStoreError(Exception):
    pass

@dataclass
class DataStore:
    root: Path
    _mem: dict = field(default_factory=dict)

    def put(self, key: str, value) -> None:
        logger.info(f"[DataStore] put {key}")
        self._mem[key] = value

    def get(self, key: str, default=None):
        return self._mem.get(key, default)

    def save_json(self, name: str, data: dict) -> str:
        self.root.mkdir(parents=True, exist_ok=True)
        path = self.root / f"{name}.json"
        path.write_text(json.dumps(data, indent=2), encoding="utf-8")
        logger.info(f"[DataStore] wrote {path}")
        return str(path)

    def load_json(self, name: str) -> dict:
        path = self.root / f"{name}.json"
        if not path.exists():
            raise DataStoreError(f"{path} not found")
        return json.loads(path.read_text(encoding="utf-8"))

class TestDataStore:
    """Robot library exposing keywords; suite-scoped shared state."""
    ROBOT_LIBRARY_SCOPE = "SUITE"
    ROBOT_LIBRARY_VERSION = "1.0"

    def __init__(self, dir: str = "artifacts/data"):
        self.store = DataStore(root=Path(dir))

    def create_unique_user(self, prefix: str = "user") -> dict:
        uid = f"{prefix}_{uuid.uuid4().hex[:8]}"
        user = {"username": uid, "created_at": int(time.time())}
        self.store.put("last_user", user)
        self.store.save_json(uid, user)
        return user

    def get_last_user(self) -> dict | None:
        return self.store.get("last_user")

    def load_user(self, name: str) -> dict:
        return self.store.load_json(name)
