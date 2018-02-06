class Portmidi < Formula
  desc "Cross-platform library for real-time MIDI I/O"
  homepage "https://sourceforge.net/projects/portmedia/"
  url "https://downloads.sourceforge.net/project/portmedia/portmidi/217/portmidi-src-217.zip"
  sha256 "08e9a892bd80bdb1115213fb72dc29a7bf2ff108b378180586aa65f3cfd42e0f"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "948ed9ae171a6b90ec4b72ba7cc5f16e32741a39892a489eb9fdce624dbf4a32" => :high_sierra
    sha256 "07fa27a7e35c182d3e2862c05e81a114c69ca04fb0b10077477ff115725200e1" => :sierra
    sha256 "2305ce4c560b529591a3f48180d2082f046d039e64b0121d05204a94e29399e6" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build

  def install
    if MacOS.version == :sierra || MacOS.version == :el_capitan
      ENV["SDKROOT"] = MacOS.sdk_path
    end

    inreplace "pm_mac/Makefile.osx", "PF=/usr/local", "PF=#{prefix}"

    # need to create include/lib directories since make won't create them itself
    include.mkpath
    lib.mkpath

    # Fix outdated SYSROOT to avoid:
    # No rule to make target `/Developer/SDKs/MacOSX10.5.sdk/...'
    inreplace "pm_common/CMakeLists.txt",
              "set(CMAKE_OSX_SYSROOT /Developer/SDKs/MacOSX10.5.sdk CACHE",
              "set(CMAKE_OSX_SYSROOT /#{MacOS.sdk_path} CACHE"

    system "make", "-f", "pm_mac/Makefile.osx"
    system "make", "-f", "pm_mac/Makefile.osx", "install"

    cd "pm_python" do
      # There is no longer a CHANGES.txt or TODO.txt.
      inreplace "setup.py" do |s|
        s.gsub! "CHANGES = open('CHANGES.txt').read()", 'CHANGES = ""'
        s.gsub! "TODO = open('TODO.txt').read()", 'TODO = ""'
      end
      # Provide correct dirs (that point into the Cellar)
      ENV.append "CFLAGS", "-I#{include}"
      ENV.append "LDFLAGS", "-L#{lib}"

      ENV.prepend_path "PYTHONPATH", Formula["cython"].opt_libexec/"lib/python2.7/site-packages"
      system "python", *Language::Python.setup_install_args(prefix)
    end
  end
end
