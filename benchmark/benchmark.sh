#!/usr/bin/env sh

echo "Starting benchmark, make sure jar and native image are up-to-date by running \`./mvnw spring-boot:build-image\` first"
# Startup the pods

docker-compose stop demo-jre demo-native
docker-compose up -d demo-jre demo-native
# Wait 5s
sleep 5
mkdir -p results
# Grab docker stats
docker stats benchmark_demo-native_1 benchmark_demo-jre_1 --no-stream > results/stats-after-startup.txt
# Start benchmark in parallel for both native and jre
docker-compose run bench-demo-jre > /dev/null &
docker-compose run bench-demo-native > /dev/null &

# Capture docker stats every 1s
for i in {1..25}; do
  docker stats benchmark_demo-native_1 benchmark_demo-jre_1 --no-stream > "results/stats-run-${i}.txt"
done

# At the end capture docker stats
sleep 5
docker stats benchmark_demo-native_1 benchmark_demo-jre_1 --no-stream > results/stats-end.txt

echo "Resut of native"
vegeta report < output/native.bin
echo "Resut of JRE"
vegeta report < output/jre.bin