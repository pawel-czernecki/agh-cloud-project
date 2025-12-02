from pydantic import BaseModel


class PostIn(BaseModel):
    name: str
    content: str


class PostOut(PostIn):
    id: int
