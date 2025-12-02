import os

import mysql.connector
from sqlalchemy import Integer, String, create_engine, select
from sqlalchemy.orm import Mapped, Session, DeclarativeBase, mapped_column, sessionmaker

import aws


def mysql_connection_factory():
    db_creds = aws.get_db_creds()

    return mysql.connector.connect(
        username=db_creds["username"], 
        password=db_creds["password"],
        host=os.environ["DB_HOST"], 
        port=int(os.environ["DB_PORT"]), 
        database=os.environ["DB_DATABASE"], 
        pool_name="foobar",
        pool_size=1,
    )


# engine = create_engine("sqlite:///testing.db")

engine = create_engine(
    "mysql+mysqlconnector://",
    creator=mysql_connection_factory,
    pool_pre_ping=True,
)


SessionLocal = sessionmaker(bind=engine)


def get_db_session():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


class Base(DeclarativeBase):
    pass


class Post(Base):
    __tablename__ = "posts"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String(64))
    content: Mapped[str] = mapped_column(String(64))


def init_db():
    Base.metadata.create_all(bind=engine)


def get_post(db: Session, post_id: int):
    res = db.scalars(select(Post).where(Post.id == post_id))

    return res.one_or_none()


def add_post(db: Session, name: str, content: str) -> Post:
    post = Post(name=name, content=content)

    db.add(post)
    db.commit()
    db.refresh(post)

    return post
