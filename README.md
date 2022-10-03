# README

実際に使う人はいないと思いますが、もし利用する場合は自己責任でお願いします。  
このプロダクトを運用して自動投票を行った結果発生した如何なる損害についても、開発者は一切の責任を負いかねますので御了承ください。

## リポジトリのclone

```bash
$ cd /path/to/somewhere
$ git clone git@github.com:k0kishima/teleboat_agent.git
```

## 環境変数の設定

`.env` の雛形をコピーして適宜編集

```
cp .env.example .env
vi .env
```

## Docker コンテナの起動

付属の `Dockerfile` を利用する場合、以下が一例

```bash
docker build -t teleboat_agent .
docker run --name teleboat_agent_efemeral --rm -it -v $PWD:/webapp -w /webapp -p 9999:3000 --network=default teleboat_agent bash -c "bundle install && rm -f tmp/pids/server.pid && rails s -b 0.0.0.0"
```

※ M1, M2 などAMD系のCPU搭載のMacだと `--platform=linux/amd64` オプションをつければコンテナは作れるが、Chromeがクラッシュするので現時点では Intel CPU 使ってるモデルのみ対応
