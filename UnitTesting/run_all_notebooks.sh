#!/bin/bash

for i in *.ipynb; do

    echo $i;

    # First clean up any mess made by notebook.
    git clean -fdq

    # NRPy+ Jupyter notebooks are completely Python 2/3 cross-compatible.
    #   However `jupyter nbconvert` will refuse to run if the notebook
    #   was generated using a different kernel. Here we fool Jupyter
    #   to think the notebook was written using the native python kernel.
    PYTHONMAJORVERSION=`python -c "import sys;print(sys.version_info[0])"`
    if (( $PYTHONMAJORVERSION == 3 )); then
        cat $i | sed "s/   \"name\": \"python2\"/   \"name\": \"python3\"/g" > $i-tmp ; mv $i-tmp $i
    else
        cat $i | sed "s/   \"name\": \"python3\"/   \"name\": \"python2\"/g" > $i-tmp ; mv $i-tmp $i
    fi

    jupyter nbconvert --to notebook --inplace --execute --ExecutePreprocessor.timeout=-1 $i

    echo "^^^" $i "^^^"
    echo

done

# Clean up any mess made by last notebook run
git clean -fdq
