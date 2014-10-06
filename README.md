Golang packages

By default it will build packages for el7. Just run `make` and fix the errors
as they are printed. Eventually it will work.

    make

If you wish to build packages for el6, run the follow commands.

    source targets/el6.sh
    make

Either way, your RPMs will be in out/rpms/
