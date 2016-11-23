class Mpich < Formula
  desc "Implementation of the MPI Message Passing Interface standard"
  homepage "https://www.mpich.org/"
  url "https://www.mpich.org/static/downloads/3.2/mpich-3.2.tar.gz"
  mirror "https://fossies.org/linux/misc/mpich-3.2.tar.gz"
  sha256 "0778679a6b693d7b7caff37ff9d2856dc2bfc51318bf8373859bfa74253da3dc"
  revision 2

  bottle do
    rebuild 1
    sha256 "f5715510b40e02bf6ac3c667c69c2afc8e51a7cfa986d3b72c298d3bc56756cf" => :sierra
    sha256 "b32c33e88132111b107e54d3e8224850eb7fb76a901b2d922ddd6b2d5408a9a6" => :el_capitan
    sha256 "4508eabec160ad88f4d8dc1c75568508aed7c363c36a4a491fd4ba91eb64ea77" => :yosemite
  end

  devel do
    url "https://www.mpich.org/static/downloads/3.3a2/mpich-3.3a2.tar.gz"
    sha256 "5d408e31917c5249bf5e35d1341afc34928e15483473dbb4e066b76c951125cf"
  end

  head do
    url "git://git.mpich.org/mpich.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end
  deprecated_option "disable-fortran" => "without-fortran"

  depends_on :fortran => :recommended

  conflicts_with "open-mpi", :because => "both install mpi__ compiler wrappers"

  def install
    # Fix segfault; remove for next mpich releaase > 3.2
    if build.stable? && ENV.compiler == :clang
      inreplace "src/include/mpiimpl.h",
        "} MPID_Request ATTRIBUTE((__aligned__(32)));",
        "} ATTRIBUTE((__aligned__(32))) MPID_Request;"
    end

    if build.head?
      # ensure that the consistent set of autotools built by homebrew is used to
      # build MPICH, otherwise very bizarre build errors can occur
      ENV["MPICH_AUTOTOOLS_DIR"] = HOMEBREW_PREFIX + "bin"
      system "./autogen.sh"
    end

    args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--mandir=#{man}",
    ]

    args << "--disable-fortran" if build.without? "fortran"

    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"hello.c").write <<-EOS.undent
      #include <mpi.h>
      #include <stdio.h>

      int main()
      {
        int size, rank, nameLen;
        char name[MPI_MAX_PROCESSOR_NAME];
        MPI_Init(NULL, NULL);
        MPI_Comm_size(MPI_COMM_WORLD, &size);
        MPI_Comm_rank(MPI_COMM_WORLD, &rank);
        MPI_Get_processor_name(name, &nameLen);
        printf("[%d/%d] Hello, world! My name is %s.\\n", rank, size, name);
        MPI_Finalize();
        return 0;
      }
    EOS
    system "#{bin}/mpicc", "hello.c", "-o", "hello"
    system "./hello"
    system "#{bin}/mpirun", "-np", "4", "./hello"
    if build.with? "fortran"
      (testpath/"hellof.f90").write <<-EOS.undent
        program hello
        include 'mpif.h'
        integer rank, size, ierror, tag, status(MPI_STATUS_SIZE)
        call MPI_INIT(ierror)
        call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierror)
        call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierror)
        print*, 'node', rank, ': Hello Fortran world'
        call MPI_FINALIZE(ierror)
        end
      EOS
      system "#{bin}/mpif90", "hellof.f90", "-o", "hellof"
      system "./hellof"
      system "#{bin}/mpirun", "-np", "4", "./hellof"
    end
  end
end
