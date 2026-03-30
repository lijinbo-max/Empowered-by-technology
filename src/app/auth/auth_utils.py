from passlib.hash import bcrypt

# 密码哈希
def hash_password(password):
    return bcrypt.hash(password)

# 密码验证
def verify_password(password, hashed_password):
    return bcrypt.verify(password, hashed_password)
