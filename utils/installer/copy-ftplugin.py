import os
import subprocess
HOME = os.path.expanduser('~')
LUNARVIM_DIR = os.path.join("/home/david",".local/share/lunarvim")
FTPLUGIN_DIR = os.path.join(LUNARVIM_DIR, "site/after/ftplugin")

def get_all_ft(dir):
    for _, _, filenames in os.walk(dir):
        for filename in filenames:
            yield filename 


def main():
    example_dir = os.path.join(LUNARVIM_DIR,"lvim/utils/installer/ftplugin-example")

    for example_ft in get_all_ft(example_dir):
        ft = str.replace(example_ft,".example","")
        origin_ft = os.path.join(FTPLUGIN_DIR,ft)
    
        if os.path.exists(origin_ft):
            subprocess.run(["rm","-f",origin_ft])

        subprocess.run(["cp",os.path.join(example_dir,example_ft),origin_ft])

if __name__ == "__main__":
    main()
