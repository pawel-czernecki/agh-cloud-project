from contextlib import asynccontextmanager
from typing import Annotated

from fastapi import Depends, FastAPI, HTTPException, Path, status
from sqlalchemy.orm import Session

import models as m
import database as db


@asynccontextmanager
async def lifespan(_: FastAPI):
    db.init_db()

    yield


app = FastAPI(lifespan=lifespan)


dbDep = Annotated[Session, Depends(db.get_db_session)]


@app.get("/posts/{post_id}")
def get_post(post_id: Annotated[int, Path()], s: dbDep) -> m.PostOut:
    db_post = db.get_post(s, post_id)

    if db_post is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Post does not exist")

    return m.PostOut(
        id=db_post.id,
        name=db_post.name,
        content=db_post.content,
    )


@app.post("/posts")
def add_post(req_data: m.PostIn, s: dbDep) -> m.PostOut:
    db_post = db.add_post(s, req_data.name, req_data.content)

    return m.PostOut(
        id=db_post.id,
        name=db_post.name,
        content=db_post.content,
    )
