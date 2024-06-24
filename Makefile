# 加载环境变量
include .env

# 设置环境变量
# $(shell ...) :用来执行shell命令，并返回输出结果
# sed 's/=.*//' .env: 读取env文件，并去掉等号后面的内容，只保留变量名称
# export：将变量赋值到环境变量中
export $(shell sed 's/=.*//' .env)

build:
	@echo "编译合约..."
	forge build
	@echo "编译合约完成"

deploy:
	@echo "部署合约..."
	forge script script/DeployMyNFT.s.sol:DeployMyNFT --rpc-url $(LOCAL_RPC_URL) --broadcast --private-key $(LOCAL_PRIVATE_KEY)
	@echo "部署合约完成"

all: build deploy