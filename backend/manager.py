import jwt
from pydantic import BaseModel, Field

from models.auth import Response, TokenPayload


class JWTSettings(BaseModel):
    """JWT Configuration Settings"""

    secret_key: str = Field(default="SECRET_KEY")


class JWTmanager:
    """JWT MANAGEMENT"""

    def __init__(self, setting: JWTSettings) -> None:
        self.settings = setting

    def verify(self, token: str) -> Response:
        try:
            jwt.decode(token, self.settings.secret_key, algorithms=["HS256"])
            return Response(success=True, token=token)
        except jwt.ExpiredSignatureError:
            return Response(success=False, error="Token Expired")
        except jwt.InvalidTokenError:
            return Response(success=False, error="Invalid Token")

    def encode(self, payload: TokenPayload):
        token = jwt.encode(
            payload.__dict__, self.settings.secret_key, algorithm="HS256"
        )
        return Response(success=True, token=token)


if __name__ == "__main__":
    jwt_manager = JWTmanager(JWTSettings())
    r = jwt_manager.encode(TokenPayload(role="user", username="test@gmail.com"))
    print(r.token)

    print(jwt_manager.verify(r.token or ""))
