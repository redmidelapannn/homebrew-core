class Pypy < Formula
  desc "Highly performant implementation of Python 2 in Python"
  homepage "https://pypy.org/"
  url "https://bitbucket.org/pypy/pypy/downloads/pypy2.7-v7.3.0-src.tar.bz2"
  sha256 "b0b25c7f8938ab0fedd8dedf26b9e73c490913b002b484c1b2f19d5844a518de"
  head "https://foss.heptapod.net/pypy/pypy", :using => :hg

  bottle do
    cellar :any
    rebuild 1
    sha256 "faf53be0f01d20a2c3b140e3105094631c9e5ef13b91061b2d3e086464b6a7b8" => :catalina
    sha256 "e03d5d085361d9c1462258d2ebeef4082191e2dbdee052df3c297e22de397a21" => :mojave
    sha256 "0138ed59286396ba875b19050b8d00ae73889349e6adec7bb5d8a200f6260327" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on :arch => :x86_64
  depends_on "gdbm"
  # pypy does not find system libffi, and its location cannot be given
  # as a build option
  depends_on "libffi" if DevelopmentTools.clang_build_version >= 1000
  depends_on "openssl@1.1"
  depends_on "sqlite"
  depends_on "tcl-tk"

  uses_from_macos "expat"
  uses_from_macos "unzip"
  uses_from_macos "zlib"

  resource "bootstrap" do
    url "https://bitbucket.org/pypy/pypy/downloads/pypy2.7-v7.3.0-osx64.tar.bz2"
    version "7.3.0"
    sha256 "ca7b056b243a6221ad04fa7fc8696e36a2fb858396999dcaa31dbbae53c54474"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/b0/f3/44da7482ac6da3f36f68e253cb04de37365b3dba9036a3c70773b778b485/setuptools-44.0.0.zip"
    sha256 "e5baf7723e5bb8382fc146e33032b241efc63314211a3a120aaa55d62d2bb008"
  end

  resource "pip" do
    url "https://files.pythonhosted.org/packages/ce/ea/9b445176a65ae4ba22dce1d93e4b5fe182f953df71a145f557cffaffc1bf/pip-19.3.1.tar.gz"
    sha256 "21207d76c1031e517668898a6b46a9fb1501c7a4710ef5dfd6a40ad9e6757ea7"
  end

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", "#{prefix}/opt/tcl-tk/lib/pkgconfig"
    ENV.prepend "LDFLAGS", "-L#{prefix}/opt/tcl-tk/lib"
    ENV.prepend "CPPFLAGS", "-I#{prefix}/opt/tcl-tk/include"
    # Having PYTHONPATH set can cause the build to fail if another
    # Python is present, e.g. a Homebrew-provided Python 2.x
    # See https://github.com/Homebrew/homebrew/issues/24364
    ENV["PYTHONPATH"] = ""
    ENV["PYPY_USESSION_DIR"] = buildpath

    # Fix build on High Sierra
    inreplace "lib_pypy/_tkinter/tklib_build.py" do |s|
      s.gsub! "/System/Library/Frameworks/Tk.framework/Versions/Current/Headers/",
              "#{prefix}/opt/tcl-tk/include"
      s.gsub! "libdirs = []",
              "libdirs = ['#{prefix}/opt/tcl-tk/lib']"
    end

    resource("bootstrap").stage buildpath/"bootstrap"
    python = buildpath/"bootstrap/bin/pypy"

    cd "pypy/goal" do
      system python, buildpath/"rpython/bin/rpython",
             "-Ojit", "--shared", "--cc", ENV.cc, "--verbose",
             "--make-jobs", ENV.make_jobs, "targetpypystandalone.py"
    end

    libexec.mkpath
    cd "pypy/tool/release" do
      package_args = %w[--archive-name pypy --targetdir .]
      system python, "package.py", *package_args
      system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xf", "pypy.tar.bz2"
    end

    (libexec/"lib").install libexec/"bin/libpypy-c.dylib"
    MachO::Tools.change_install_name("#{libexec}/bin/pypy",
                                     "@rpath/libpypy-c.dylib",
                                     "#{libexec}/lib/libpypy-c.dylib")

    # The PyPy binary install instructions suggest installing somewhere
    # (like /opt) and symlinking in binaries as needed. Specifically,
    # we want to avoid putting PyPy's Python.h somewhere that configure
    # scripts will find it.
    bin.install_symlink libexec/"bin/pypy"
    lib.install_symlink libexec/"lib/libpypy-c.dylib"
  end

  def post_install
    # Post-install, fix up the site-packages and install-scripts folders
    # so that user-installed Python software survives minor updates, such
    # as going from 1.7.0 to 1.7.1.

    # Create a site-packages in the prefix.
    prefix_site_packages.mkpath

    # Symlink the prefix site-packages into the cellar.
    unless (libexec/"site-packages").symlink?
      # fix the case where libexec/site-packages/site-packages was installed
      rm_rf libexec/"site-packages/site-packages"
      mv Dir[libexec/"site-packages/*"], prefix_site_packages
      rm_rf libexec/"site-packages"
    end
    libexec.install_symlink prefix_site_packages

    # Tell distutils-based installers where to put scripts
    scripts_folder.mkpath
    (distutils+"distutils.cfg").atomic_write <<~EOS
      [install]
      install-scripts=#{scripts_folder}
    EOS

    %w[setuptools pip].each do |pkg|
      resource(pkg).stage do
        system bin/"pypy", "-s", "setup.py", "--no-user-cfg", "install",
               "--force", "--verbose"
      end
    end

    # Symlinks to easy_install_pypy and pip_pypy
    bin.install_symlink scripts_folder/"easy_install" => "easy_install_pypy"
    bin.install_symlink scripts_folder/"pip" => "pip_pypy"

    # post_install happens after linking
    %w[easy_install_pypy pip_pypy].each { |e| (HOMEBREW_PREFIX/"bin").install_symlink bin/e }
  end

  def caveats; <<~EOS
    A "distutils.cfg" has been written to:
      #{distutils}
    specifying the install-scripts folder as:
      #{scripts_folder}

    If you install Python packages via "pypy setup.py install", easy_install_pypy,
    or pip_pypy, any provided scripts will go into the install-scripts folder
    above, so you may want to add it to your PATH *after* #{HOMEBREW_PREFIX}/bin
    so you don't overwrite tools from CPython.

    Setuptools and pip have been installed, so you can use easy_install_pypy and
    pip_pypy.
    To update setuptools and pip between pypy releases, run:
        pip_pypy install --upgrade pip setuptools

    See: https://docs.brew.sh/Homebrew-and-Python
  EOS
  end

  # The HOMEBREW_PREFIX location of site-packages
  def prefix_site_packages
    HOMEBREW_PREFIX+"lib/pypy/site-packages"
  end

  # Where setuptools will install executable scripts
  def scripts_folder
    HOMEBREW_PREFIX+"share/pypy"
  end

  # The Cellar location of distutils
  def distutils
    libexec+"lib-python/2.7/distutils"
  end

  test do
    system bin/"pypy", "-c", "print('Hello, world!')"
    system bin/"pypy", "-c", "import time; time.clock()"
    system scripts_folder/"pip", "list"
  end
end
