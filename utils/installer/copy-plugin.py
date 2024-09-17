import os
import subprocess
from pathlib import Path

HOME = os.path.expanduser('~')
LUNARVIM_DIR = os.path.join("/home/david",".local/share/lunarvim")
PACKER_DIR = os.path.join(LUNARVIM_DIR, "site/pack/packer/start")
EXAMPLE_DIR = os.path.join(LUNARVIM_DIR,"lvim/utils/installer/plugin-example")

def main():
    example_dict = { } 

    for dirpath, _, filenames in os.walk(EXAMPLE_DIR):
        for filename in filenames:
            # /home/david/.local/share/lunarvim/lvim/utils/installer/plugin-example/cmake/config.lua
            absolute_path_example_config = os.path.join(dirpath, str.replace(filename, ".example",""))
            # cmake/config.lua
            pattern = os.path.join(Path(absolute_path_example_config).parent.name, Path(absolute_path_example_config).name)
           
            # key:cmake/config.lua; 
            # value:/home/david/.local/share/lunarvim/lvim/utils/installer/plugin-example/cmake/config.example.lua
            example_dict.__setitem__(pattern, os.path.join(dirpath, filename))

    for dirpath, _, filenames in os.walk(PACKER_DIR):
        for filename in filenames:
            absolute_path_config = os.path.join(dirpath, filename)
            pattern = os.path.join(Path(absolute_path_config).parent.name, Path(absolute_path_config).name)            
            if example_dict.get(pattern) != None:
                absolute_path_example_config = Path(example_dict.get(pattern,""))
                subprocess.run([ "cp", absolute_path_config, absolute_path_config + ".back" ])
                subprocess.run([ "cp", absolute_path_example_config, absolute_path_config ])


if __name__ == "__main__":
   main()
