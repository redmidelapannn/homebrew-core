class OpenMpi < Formula
  desc "High performance message passing library"
  homepage "https://www.open-mpi.org/"

  stable do
    # These can be put back up under `homepage` once Open MPI v3.1.1 is released:
    url "https://www.open-mpi.org/software/ompi/v3.1/downloads/openmpi-3.1.0.tar.bz2"
    sha256 "b25c044124cc859c0b4e6e825574f9439a51683af1950f6acda1951f5ccdf06c"

    # Fix https://github.com/Homebrew/homebrew-core/issues/26009 and its upstream counterpart
    # https://github.com/open-mpi/ompi/issues/5000 for the time being.
    #
    # (Remove this patch when Open MPI v3.1.1 is shipped upstream, as it will be included in that
    # release.)
    #
    # From the result of https://github.com/open-mpi/ompi/pull/5015 and
    # https://github.com/open-mpi/ompi/pull/5160 as backported to Open MPI v3.1.x by
    # https://github.com/open-mpi/ompi/pull/5118:
    patch do
      url "https://github.com/open-mpi/ompi/commit/c99cf1ae6e929f7f2ab61262337db5fb49662ab3.patch?full_index=1"
      sha256 "07a927e0c2489391850d61399d7a282db81de1dab24ea60304dd33c2ad8c430f"
    end
  end

  bottle do
    rebuild 1
    sha256 "341d4f75190d25a539aee0c432dd1b5490ef953995b55758af02b48f9e869680" => :high_sierra
    sha256 "28535296a8f6486af0ff1a929c5e8f83fe8569bd3d01cab46a04f1041aefcb2b" => :sierra
    sha256 "d5d383d327501c89e9dbd556476b4f4c3d4675721e664b7f36588b84fedd4c66" => :el_capitan
  end

  head do
    url "https://github.com/open-mpi/ompi.git"
    # Uncomment the following lines once the `stable` `SoftwareSpec` isn't being patched any more:
    # depends_on "automake" => :build
    # depends_on "autoconf" => :build
    # depends_on "libtool" => :build
  end

  option "with-mpi-thread-multiple", "Enable MPI_THREAD_MULTIPLE"
  option "with-cxx-bindings", "Enable C++ MPI bindings (deprecated as of MPI-3.0)"
  option "without-fortran", "Do not build the Fortran bindings"

  deprecated_option "disable-fortran" => "without-fortran"
  deprecated_option "enable-mpi-thread-multiple" => "with-mpi-thread-multiple"

  # Some build dependencies were added here for the above patch and can will no longer be relevant
  # once Open MPI v3.1.1 is released:
  #
  #   - autoconf
  #   - automake
  #   - libtool
  #
  # As such, the lines declaring these can be removed below after this happens.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" if build.with? "fortran"
  depends_on :java => :optional
  depends_on "libevent"

  conflicts_with "mpich", :because => "both install MPI compiler wrappers"

  needs :cxx11

  def install
    # otherwise libmpi_usempi_ignore_tkr gets built as a static library
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-ipv6
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-sge
    ]
    args << "--with-platform-optimized" if build.head?
    args << "--disable-mpi-fortran" if build.without? "fortran"
    args << "--enable-mpi-thread-multiple" if build.with? "mpi-thread-multiple"
    args << "--enable-mpi-java" if build.with? "java"
    args << "--enable-mpi-cxx" if build.with? "cxx-bindings"

    # Change the `autogen.pl` handling back to `system "./autogen.pl if build.head?` once Open
    # MPI v3.1.1 is released:
    if build.stable?
      autogen_args = %w[--force]
    elsif build.head?
      autogen_args = %w[]
    end
    system "./autogen.pl", *autogen_args
    system "./configure", *args
    system "make", "all"
    system "make", "check"
    system "make", "install"

    # If Fortran bindings were built, there will be stray `.mod` files
    # (Fortran header) in `lib` that need to be moved to `include`.
    include.install Dir["#{lib}/*.mod"] if build.with? "fortran"
  end

  test do
    (testpath/"hello.c").write <<~EOS
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
    system bin/"mpicc", "hello.c", "-o", "hello"
    system "./hello"
    system bin/"mpirun", "./hello"
    (testpath/"hellof.f90").write <<~EOS
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
    system bin/"mpif90", "hellof.f90", "-o", "hellof"
    system "./hellof"
    system bin/"mpirun", "./hellof"
  end
end
