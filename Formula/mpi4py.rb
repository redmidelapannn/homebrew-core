class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.readthedocs.io"
  url "https://bitbucket.org/mpi4py/mpi4py/downloads/mpi4py-3.0.3.tar.gz"
  sha256 "012d716c8b9ed1e513fcc4b18e5af16a8791f51e6d1716baccf988ad355c5a1f"
  revision 1

  bottle do
    cellar :any
    sha256 "34bf70188699739bb931808d524dce693bb2c452469b32316e1bddda12468a91" => :mojave
    sha256 "c857e238d534085150c99af67d1378bc2044f95e45907c20477662fa29b810a4" => :high_sierra
  end

  depends_on "cython" => :build
  depends_on "open-mpi"
  depends_on "python"

  def install
    system "#{Formula["python"].opt_bin}/python3",
           *Language::Python.setup_install_args(libexec)

    system "python3", "setup.py",
      "build", "--mpicc=mpicc -shared", "--parallel=#{ENV.make_jobs}",
      "install", "--prefix=#{prefix}",
      "--single-version-externally-managed", "--record=installed.txt"
  end

  test do
    system "#{Formula["python"].opt_bin}/python3",
           "-c", "import mpi4py"
    system "#{Formula["python"].opt_bin}/python3",
           "-c", "import mpi4py.MPI"
    system "#{Formula["python"].opt_bin}/python3",
           "-c", "import mpi4py.futures"
    system "mpiexec", "-n", "4", "#{Formula["python"].opt_bin}/python3",
           "-m", "mpi4py.run", "-m", "mpi4py.bench", "helloworld"
    system "mpiexec", "-n", "4", "#{Formula["python"].opt_bin}/python3",
           "-m", "mpi4py.run", "-m", "mpi4py.bench", "ringtest",
           "-l", "10", "-n", "1024"
  end
end
