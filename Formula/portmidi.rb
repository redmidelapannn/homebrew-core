class Portmidi < Formula
  desc "Cross-platform library for real-time MIDI I/O"
  homepage "https://sourceforge.net/projects/portmedia/"
  url "https://downloads.sourceforge.net/project/portmedia/portmidi/217/portmidi-src-217.zip"
  sha256 "08e9a892bd80bdb1115213fb72dc29a7bf2ff108b378180586aa65f3cfd42e0f"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "4ce5412d943dd47503674dc33b06b3b922f8594eb04a596836773c2691467c2c" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "cython" => :build

  def install
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
