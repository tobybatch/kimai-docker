#!/usr/bin/env bats
  
load test_helper

@test "image build dev" {
  run build_image $NAME:dev $BATS_TEST_DIRNAME/../dev
  [ "$status" -eq 0 ]
}

@test "image start dev" {
  run run_image --name $CONTAINER_NAME -d $NAME:dev
  [ "$status" -eq 0 ]
}

# @test "existing source tree" {
    # run fetch_source_repo $REPO_DIR
    # [ "$status" -eq 0 ]
# 
    # run run_image -v $REPO_DIR/src:/opt/kimai/src -v $BATS_TEST_DIRNAME/test.sqlite:/opt/kimai/var/data/kimai.sqlite --user root -ti ${NAME}:dev composer --working-dir=/opt/kimai install
    # [ "$status" -eq 0 ]
# 
    # cp $BATS_TEST_DIRNAME/test.sqlite $REPO_DIR/var/data/kimai.sqlite
# 
    # run run_image -v $REPO_DIR:/opt/kimai -d --name $CONTAINER_NAME ${NAME}:dev
    # [ "$status" -eq 0 ]
# 
    # docker run -v $BATS_TEST_DIRNAME/test.sqlite:/kimai.sqlite --rm ubuntu chown 33:33 /kimai.sqlite
    # [ "$status" -eq 0 ]
# 
    # run execute_cmd bin/console fos:user:promote tobias ROLE_ADMIN
    # [ "$status" -eq 0 ]
# }

