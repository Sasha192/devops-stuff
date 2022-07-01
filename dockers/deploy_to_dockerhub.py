import os


ALMA = ""
cmd_retag = ""
cmd_push = ""


def docker_creds():
    docker_id = os.getenv("DOCKER_ID", os.environ.get("DOCKER_ID"))
    docker_pwd = os.getenv("DOCKER_PWD", os.environ.get("DOCKER_PWD"))
    return {
        "docker_id": docker_id,
        "docker_pwd": docker_pwd
    }


def cmd_execute(cmd):
    print('executing:\n' + cmd)
    stream = os.popen(cmd)
    print("completed")


def push_images(tags, creds):
    cmd_push = ""
    length = len(tags)
    for iter in range(0, len(image_names)):
        new_name = tags[iter]
        cmd_push = cmd_push + " sudo docker push " + new_name
        if iter < length - 1:
            cmd_push = cmd_push + " && "
    os.system(cmd_push)
    cmd = "echo " + creds["docker_pwd"] + " | sudo docker login -u " + creds["docker_id"] + " --password-stdin | " + cmd_push
    cmd_execute(cmd)


if __name__ == "__main__":
    image_names = ["jenkins-maven"]
    creds = docker_creds()
    push_images(tags=image_names, creds=creds)
    print("completed.")
