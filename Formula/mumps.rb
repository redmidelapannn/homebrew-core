class Mumps < Formula
  desc "Parallel Sparse Direct Solver"
  homepage "http://mumps-solver.org"
  url "http://mumps.enseeiht.fr/MUMPS_5.1.2.tar.gz"
  sha256 "eb345cda145da9aea01b851d17e54e7eef08e16bfa148100ac1f7f046cd42ae9"

  depends_on :mpi => [:cc, :cxx, :f90]
  depends_on :fortran
  depends_on "openblas"
  depends_on "scalapack"
  depends_on "parmetis"
  depends_on "scotch"

  resource "mumps_simple" do
    url "https://github.com/dpo/mumps_simple/archive/v0.4.tar.gz"
    sha256 "87d1fc87eb04cfa1cba0ca0a18f051b348a93b0b2c2e97279b23994664ee437e"
  end

  def install
    make_args = ["RANLIB=echo"]
    # Building dylibs with mpif90 causes segfaults on 10.8 and 10.10. Use gfortran.
    shlibs_args = ["LIBEXT=.dylib",
                   "AR=#{ENV["FC"]} -dynamiclib -Wl,-install_name -Wl,#{lib}/$(notdir $@) -undefined dynamic_lookup -o "]
    make_args += ["OPTF=-O", "CDEFS=-DAdd_"]
    orderingsf = "-Dpord"

    makefile = "Makefile.G95.PAR"
    cp "Make.inc/" + makefile, "Makefile.inc"

    make_args += ["SCOTCHDIR=#{Formula["scotch"].opt_prefix}",
                  "ISCOTCH=-I#{Formula["scotch"].opt_include}"]

    scotch_libs = "LSCOTCH=-L$(SCOTCHDIR)/lib -lptscotch -lptscotcherr -lptscotcherrexit -lscotch"
    scotch_libs += "-lptscotchparmetis"
    make_args << scotch_libs
    orderingsf << " -Dptscotch"

    make_args += ["LMETISDIR=#{Formula["parmetis"].opt_lib}",
                  "IMETIS=#{Formula["parmetis"].opt_include}",
                  "LMETIS=-L#{Formula["parmetis"].opt_lib} -lparmetis -L#{Formula["metis"].opt_lib} -lmetis"]
    orderingsf << " -Dparmetis"

    make_args << "ORDERINGSF=#{orderingsf}"

    make_args += ["CC=#{ENV["MPICC"]} -fPIC",
                  "FC=#{ENV["MPIFC"]} -fPIC",
                  "FL=#{ENV["MPIFC"]} -fPIC",
                  "SCALAP=-L#{Formula["scalapack"].opt_lib} -lscalapack",
                  "INCPAR=", # Let MPI compilers fill in the blanks.
                  "LIBPAR=$(SCALAP)"]

    make_args << "LIBBLAS=-L#{Formula["openblas"].opt_lib} -lopenblas"

    ENV.deparallelize # Build fails in parallel on Mavericks.

    system "make", "alllib", *(shlibs_args + make_args)

    lib.install Dir["lib/*"]

    # Build static libraries (e.g., for Dolfin)
    system "make", "alllib", *make_args
    (libexec/"lib").install Dir["lib/*.a"]

    inreplace "examples/Makefile" do |s|
      s.change_make_var! "libdir", lib
    end

    libexec.install "include"
    include.install_symlink Dir[libexec/"include/*"]

    doc.install Dir["doc/*.pdf"]
    pkgshare.install "examples"

    prefix.install "Makefile.inc"  # For the record.
    File.open(prefix/"make_args.txt", "w") do |f|
      f.puts(make_args.join(" "))  # Record options passed to make.
    end

    resource("mumps_simple").stage do
      simple_args = ["CC=#{ENV["MPICC"]}", "prefix=#{prefix}", "mumps_prefix=#{prefix}",
                     "scalapack_libdir=#{Formula["scalapack"].opt_lib}"]
      simple_args += ["scotch_libdir=#{Formula["scotch"].opt_lib}",
                      "scotch_libs=-L$(scotch_libdir) -lptscotch -lptscotcherr -lscotch"]
      simple_args += ["blas_libdir=#{Formula["openblas"].opt_lib}",
                      "blas_libs=-L$(blas_libdir) -lopenblas"]
      system "make", "SHELL=/bin/bash", *simple_args
      lib.install "libmumps_simple.dylib"
      include.install "mumps_simple.h"
    end
  end

  def caveats
    s = <<-EOS.undent
      MUMPS was built with shared libraries. If required,
      static libraries are available in
        #{opt_libexec}/lib
    EOS
    s
  end

  test do
    ENV.fortran
    cp_r pkgshare/"examples", testpath
    opts = ["-I#{opt_include}", "-L#{opt_lib}", "-lmumps_common", "-lpord"]
    opts << "-L#{Formula["openblas"].opt_lib}" << "-lopenblas"
    f90 = "mpif90"
    cc = "mpicc"
    mpirun = "mpirun -np 2"
    opts << "-lscalapack"

    cd testpath/"examples" do
      system f90, "-o", "ssimpletest", "ssimpletest.F", "-lsmumps", *opts
      system "#{mpirun} ./ssimpletest < input_simpletest_real"
      system f90, "-o", "dsimpletest", "dsimpletest.F", "-ldmumps", *opts
      system "#{mpirun} ./dsimpletest < input_simpletest_real"
      system f90, "-o", "csimpletest", "csimpletest.F", "-lcmumps", *opts
      system "#{mpirun} ./csimpletest < input_simpletest_cmplx"
      system f90, "-o", "zsimpletest", "zsimpletest.F", "-lzmumps", *opts
      system "#{mpirun} ./zsimpletest < input_simpletest_cmplx"
      system cc, "-c", "c_example.c", "-I#{opt_include}"
      system f90, "-o", "c_example", "c_example.o", "-ldmumps", *opts
      system *(mpirun.split + ["./c_example"] + opts)
    end
  end
end
