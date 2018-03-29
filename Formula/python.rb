class Python < Formula
  desc "Interpreted, interactive, object-oriented programming language"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.6.4/Python-3.6.4.tar.xz"
  sha256 "159b932bf56aeaa76fd66e7420522d8c8853d486b8567c459b84fe2ed13bcaba"
  revision 4
  head "https://github.com/python/cpython.git"

  bottle do
    rebuild 1
    sha256 "37792966041dbb689e8901817105136c782d5def46288684fd28998731ed6f25" => :high_sierra
    sha256 "ba0739dea99c119d439a905a035fa9fa7837427c9ea73d8832a75b3eff30f7e5" => :sierra
    sha256 "a037e0adfc60991c5417e2c1aef86aade1b96eecff28441a57d2b987b78f248b" => :el_capitan
  end

  devel do
    url "https://www.python.org/ftp/python/3.7.0/Python-3.7.0b3.tar.xz"
    sha256 "2b152788486c61ee6c3e9feaeb4c3fe9679f0a76a19a4c82eb4c665989c340fb"
  end

  option "with-tcl-tk", "Use Homebrew's Tk instead of macOS Tk (has optional Cocoa and threads support)"
  deprecated_option "with-brewed-tk" => "with-tcl-tk"

  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "gdbm"
  depends_on "openssl"
  depends_on "readline"
  depends_on "sqlite"
  depends_on "xz"
  depends_on "tcl-tk" => :optional

  skip_clean "bin/pip3", "bin/pip-3.4", "bin/pip-3.5", "bin/pip-3.6"
  skip_clean "bin/easy_install3", "bin/easy_install-3.4", "bin/easy_install-3.5", "bin/easy_install-3.6"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/e0/02/2b14188e06ddf61e5b462e216b15d893e8472fca28b1b0c5d9272ad7e87c/setuptools-38.5.2.zip"
    sha256 "8246123e984cadf687163bdcd1bb58eb325e2891b066e1f0224728a41c8d9064"
  end

  resource "pip" do
    url "https://files.pythonhosted.org/packages/c4/44/e6b8056b6c8f2bfd1445cc9990f478930d8e3459e9dbf5b8e2d2922d64d3/pip-9.0.3.tar.gz"
    sha256 "7bf48f9a693be1d58f49f7af7e0ae9fe29fd671cde8a55e6edca3581c4ef5796"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/fa/b4/f9886517624a4dcb81a1d766f68034344b7565db69f13d52697222daeb72/wheel-0.30.0.tar.gz"
    sha256 "9515fe0a94e823fd90b08d22de45d7bde57c90edce705b22f5e1ecf7e1b653c8"
  end

  fails_with :clang do
    build 425
    cause "https://bugs.python.org/issue24844"
  end

  # Homebrew's tcl-tk is built in a standard unix fashion (due to link errors)
  # so we have to stop python from searching for frameworks and linking against
  # X11.
  patch :DATA if build.with? "tcl-tk"

  # setuptools remembers the build flags python is built with and uses them to
  # build packages later. Xcode-only systems need different flags.
  pour_bottle? do
    reason <<~EOS
      The bottle needs the Apple Command Line Tools to be installed.
        You can install them, if desired, with:
          xcode-select --install
    EOS
    satisfy { MacOS::CLT.installed? }
  end

  def install
    # Unset these so that installing pip and setuptools puts them where we want
    # and not into some other Python the user has installed.
    ENV["PYTHONHOME"] = nil
    ENV["PYTHONPATH"] = nil

    xy = (buildpath/"configure.ac").read.slice(/PYTHON_VERSION, (3\.\d)/, 1)
    lib_cellar = prefix/"Frameworks/Python.framework/Versions/#{xy}/lib/python#{xy}"

    args = %W[
      --prefix=#{prefix}
      --enable-ipv6
      --datarootdir=#{share}
      --datadir=#{share}
      --enable-framework=#{frameworks}
      --enable-loadable-sqlite-extensions
      --without-ensurepip
      --with-dtrace
    ]

    args << "--without-gcc" if ENV.compiler == :clang

    cflags   = []
    ldflags  = []
    cppflags = []

    unless MacOS::CLT.installed?
      # Help Python's build system (setuptools/pip) to build things on Xcode-only systems
      # The setup.py looks at "-isysroot" to get the sysroot (and not at --sysroot)
      cflags   << "-isysroot #{MacOS.sdk_path}"
      ldflags  << "-isysroot #{MacOS.sdk_path}"
      cppflags << "-I#{MacOS.sdk_path}/usr/include" # find zlib
      # For the Xlib.h, Python needs this header dir with the system Tk
      if build.without? "tcl-tk"
        cflags << "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers"
      end
    end
    # Avoid linking to libgcc https://mail.python.org/pipermail/python-dev/2012-February/116205.html
    args << "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"

    # We want our readline! This is just to outsmart the detection code,
    # superenv makes cc always find includes/libs!
    inreplace "setup.py",
      "do_readline = self.compiler.find_library_file(lib_dirs, 'readline')",
      "do_readline = '#{Formula["readline"].opt_lib}/libhistory.dylib'"

    if build.stable?
      inreplace "setup.py", "/usr/local/ssl", Formula["openssl"].opt_prefix
    else
      args << "--with-openssl=#{Formula["openssl"].opt_prefix}"
    end

    inreplace "setup.py" do |s|
      s.gsub! "sqlite_setup_debug = False", "sqlite_setup_debug = True"
      s.gsub! "for d_ in inc_dirs + sqlite_inc_paths:",
              "for d_ in ['#{Formula["sqlite"].opt_include}']:"
    end

    # Allow python modules to use ctypes.find_library to find homebrew's stuff
    # even if homebrew is not a /usr/local/lib. Try this with:
    # `brew install enchant && pip install pyenchant`
    inreplace "./Lib/ctypes/macholib/dyld.py" do |f|
      f.gsub! "DEFAULT_LIBRARY_FALLBACK = [", "DEFAULT_LIBRARY_FALLBACK = [ '#{HOMEBREW_PREFIX}/lib',"
      f.gsub! "DEFAULT_FRAMEWORK_FALLBACK = [", "DEFAULT_FRAMEWORK_FALLBACK = [ '#{HOMEBREW_PREFIX}/Frameworks',"
    end

    if build.with? "tcl-tk"
      tcl_tk = Formula["tcl-tk"].opt_prefix
      cppflags << "-I#{tcl_tk}/include"
      ldflags  << "-L#{tcl_tk}/lib"
    end

    args << "CFLAGS=#{cflags.join(" ")}" unless cflags.empty?
    args << "LDFLAGS=#{ldflags.join(" ")}" unless ldflags.empty?
    args << "CPPFLAGS=#{cppflags.join(" ")}" unless cppflags.empty?

    system "./configure", *args
    system "make"

    ENV.deparallelize do
      # Tell Python not to install into /Applications (default for framework builds)
      system "make", "install", "PYTHONAPPSDIR=#{prefix}"
      system "make", "frameworkinstallextras", "PYTHONAPPSDIR=#{pkgshare}"
    end

    # Any .app get a " 3" attached, so it does not conflict with python 2.x.
    Dir.glob("#{prefix}/*.app") { |app| mv app, app.sub(/\.app$/, " 3.app") }

    # Prevent third-party packages from building against fragile Cellar paths
    inreplace Dir[lib_cellar/"**/_sysconfigdata_m_darwin_darwin.py",
                  lib_cellar/"config*/Makefile",
                  frameworks/"Python.framework/Versions/3*/lib/pkgconfig/python-3.?.pc"],
              prefix, opt_prefix

    # Help third-party packages find the Python framework
    inreplace Dir[lib_cellar/"config*/Makefile"],
              /^LINKFORSHARED=(.*)PYTHONFRAMEWORKDIR(.*)/,
              "LINKFORSHARED=\\1PYTHONFRAMEWORKINSTALLDIR\\2"

    # Fix for https://github.com/Homebrew/homebrew-core/issues/21212
    inreplace Dir[lib_cellar/"**/_sysconfigdata_m_darwin_darwin.py"],
              %r{('LINKFORSHARED': .*?)'(Python.framework/Versions/3.\d+/Python)'}m,
              "\\1'#{opt_prefix}/Frameworks/\\2'"

    # A fix, because python and python3 both want to install Python.framework
    # and therefore we can't link both into HOMEBREW_PREFIX/Frameworks
    # https://github.com/Homebrew/homebrew/issues/15943
    ["Headers", "Python", "Resources"].each { |f| rm(prefix/"Frameworks/Python.framework/#{f}") }
    rm prefix/"Frameworks/Python.framework/Versions/Current"

    # Symlink the pkgconfig files into HOMEBREW_PREFIX so they're accessible.
    (lib/"pkgconfig").install_symlink Dir["#{frameworks}/Python.framework/Versions/#{xy}/lib/pkgconfig/*"]

    # Remove the site-packages that Python created in its Cellar.
    (prefix/"Frameworks/Python.framework/Versions/#{xy}/lib/python#{xy}/site-packages").rmtree

    %w[setuptools pip wheel].each do |r|
      (libexec/r).install resource(r)
    end

    cd "Doc" do
      system "make", "html"
      doc.install Dir["build/html/*"]
    end

    # Install unversioned symlinks in libexec/bin.
    {
      "idle" => "idle3",
      "pydoc" => "pydoc3",
      "python" => "python3",
      "python-config" => "python3-config",
    }.each do |unversioned_name, versioned_name|
      (libexec/"bin").install_symlink (bin/versioned_name).realpath => unversioned_name
    end
  end

  def post_install
    ENV.delete "PYTHONPATH"

    xy = (prefix/"Frameworks/Python.framework/Versions").children.sort.first.basename.to_s
    site_packages = HOMEBREW_PREFIX/"lib/python#{xy}/site-packages"
    site_packages_cellar = prefix/"Frameworks/Python.framework/Versions/#{xy}/lib/python#{xy}/site-packages"

    # Fix up the site-packages so that user-installed Python software survives
    # minor updates, such as going from 3.3.2 to 3.3.3:

    # Create a site-packages in HOMEBREW_PREFIX/lib/python#{xy}/site-packages
    site_packages.mkpath

    # Symlink the prefix site-packages into the cellar.
    site_packages_cellar.unlink if site_packages_cellar.exist?
    site_packages_cellar.parent.install_symlink site_packages

    # Write our sitecustomize.py
    rm_rf Dir["#{site_packages}/sitecustomize.py[co]"]
    (site_packages/"sitecustomize.py").atomic_write(sitecustomize)

    # Remove old setuptools installations that may still fly around and be
    # listed in the easy_install.pth. This can break setuptools build with
    # zipimport.ZipImportError: bad local file header
    # setuptools-0.9.8-py3.3.egg
    rm_rf Dir["#{site_packages}/setuptools*"]
    rm_rf Dir["#{site_packages}/distribute*"]
    rm_rf Dir["#{site_packages}/pip[-_.][0-9]*", "#{site_packages}/pip"]

    %w[setuptools pip wheel].each do |pkg|
      (libexec/pkg).cd do
        system bin/"python3", "-s", "setup.py", "--no-user-cfg", "install",
               "--force", "--verbose", "--install-scripts=#{bin}",
               "--install-lib=#{site_packages}",
               "--single-version-externally-managed",
               "--record=installed.txt"
      end
    end

    rm_rf [bin/"pip", bin/"easy_install"]
    mv bin/"wheel", bin/"wheel3"

    # Install unversioned symlinks in libexec/bin.
    {
      "easy_install" => "easy_install-#{xy}",
      "pip" => "pip3",
      "wheel" => "wheel3",
    }.each do |unversioned_name, versioned_name|
      (libexec/"bin").install_symlink (bin/versioned_name).realpath => unversioned_name
    end

    # post_install happens after link
    %W[pip3 pip#{xy} easy_install-#{xy} wheel3].each do |e|
      (HOMEBREW_PREFIX/"bin").install_symlink bin/e
    end

    # Help distutils find brewed stuff when building extensions
    include_dirs = [HOMEBREW_PREFIX/"include", Formula["openssl"].opt_include,
                    Formula["sqlite"].opt_include]
    library_dirs = [HOMEBREW_PREFIX/"lib", Formula["openssl"].opt_lib,
                    Formula["sqlite"].opt_lib]

    if build.with? "tcl-tk"
      include_dirs << Formula["tcl-tk"].opt_include
      library_dirs << Formula["tcl-tk"].opt_lib
    end

    cfg = prefix/"Frameworks/Python.framework/Versions/#{xy}/lib/python#{xy}/distutils/distutils.cfg"

    cfg.atomic_write <<~EOS
      [install]
      prefix=#{HOMEBREW_PREFIX}

      [build_ext]
      include_dirs=#{include_dirs.join ":"}
      library_dirs=#{library_dirs.join ":"}
    EOS
  end

  def sitecustomize
    xy = (prefix/"Frameworks/Python.framework/Versions").children.sort.first.basename.to_s

    <<~EOS
      # This file is created by Homebrew and is executed on each python startup.
      # Don't print from here, or else python command line scripts may fail!
      # <https://docs.brew.sh/Homebrew-and-Python>
      import re
      import os
      import sys

      if sys.version_info[0] != 3:
          # This can only happen if the user has set the PYTHONPATH for 3.x and run Python 2.x or vice versa.
          # Every Python looks at the PYTHONPATH variable and we can't fix it here in sitecustomize.py,
          # because the PYTHONPATH is evaluated after the sitecustomize.py. Many modules (e.g. PyQt4) are
          # built only for a specific version of Python and will fail with cryptic error messages.
          # In the end this means: Don't set the PYTHONPATH permanently if you use different Python versions.
          exit('Your PYTHONPATH points to a site-packages dir for Python 3.x but you are running Python ' +
               str(sys.version_info[0]) + '.x!\\n     PYTHONPATH is currently: "' + str(os.environ['PYTHONPATH']) + '"\\n' +
               '     You should `unset PYTHONPATH` to fix this.')

      # Only do this for a brewed python:
      if os.path.realpath(sys.executable).startswith('#{rack}'):
          # Shuffle /Library site-packages to the end of sys.path
          library_site = '/Library/Python/#{xy}/site-packages'
          library_packages = [p for p in sys.path if p.startswith(library_site)]
          sys.path = [p for p in sys.path if not p.startswith(library_site)]
          # .pth files have already been processed so don't use addsitedir
          sys.path.extend(library_packages)

          # the Cellar site-packages is a symlink to the HOMEBREW_PREFIX
          # site_packages; prefer the shorter paths
          long_prefix = re.compile(r'#{rack}/[0-9\._abrc]+/Frameworks/Python\.framework/Versions/#{xy}/lib/python#{xy}/site-packages')
          sys.path = [long_prefix.sub('#{HOMEBREW_PREFIX/"lib/python#{xy}/site-packages"}', p) for p in sys.path]

          # Set the sys.executable to use the opt_prefix
          sys.executable = '#{opt_bin}/python#{xy}'
    EOS
  end

  def caveats
    if prefix.exist?
      xy = (prefix/"Frameworks/Python.framework/Versions").children.sort.first.basename.to_s
    else
      xy = version.to_s.slice(/(3\.\d)/) || "3.6"
    end
    text = <<~EOS
      Python has been installed as
        #{HOMEBREW_PREFIX}/bin/python3

      Unversioned symlinks `python`, `python-config`, `pip` etc. pointing to
      `python3`, `python3-config`, `pip3` etc., respectively, have been installed into
        #{opt_libexec}/bin

      If you need Homebrew's Python 2.7 run
        brew install python@2

      Pip, setuptools, and wheel have been installed. To update them run
        pip3 install --upgrade pip setuptools wheel

      You can install Python packages with
        pip3 install <package>
      They will install into the site-package directory
        #{HOMEBREW_PREFIX/"lib/python#{xy}/site-packages"}

      See: https://docs.brew.sh/Homebrew-and-Python
    EOS

    # Tk warning only for 10.6
    tk_caveats = <<~EOS

      Apple's Tcl/Tk is not recommended for use with Python on Mac OS X 10.6.
      For more information see: https://www.python.org/download/mac/tcltk/
    EOS

    text += tk_caveats unless MacOS.version >= :lion
    text
  end

  test do
    xy = (prefix/"Frameworks/Python.framework/Versions").children.sort.first.basename.to_s
    # Check if sqlite is ok, because we build with --enable-loadable-sqlite-extensions
    # and it can occur that building sqlite silently fails if OSX's sqlite is used.
    system "#{bin}/python#{xy}", "-c", "import sqlite3"
    # Check if some other modules import. Then the linked libs are working.
    system "#{bin}/python#{xy}", "-c", "import tkinter; root = tkinter.Tk()"
    system "#{bin}/python#{xy}", "-c", "import _gdbm"
    system bin/"pip3", "list", "--format=columns"
  end
end

__END__
diff --git a/setup.py b/setup.py
index 2779658..902d0eb 100644
--- a/setup.py
+++ b/setup.py
@@ -1699,9 +1699,6 @@ class PyBuildExt(build_ext):
         # Rather than complicate the code below, detecting and building
         # AquaTk is a separate method. Only one Tkinter will be built on
         # Darwin - either AquaTk, if it is found, or X11 based Tk.
-        if (host_platform == 'darwin' and
-            self.detect_tkinter_darwin(inc_dirs, lib_dirs)):
-            return

         # Assume we haven't found any of the libraries or include files
         # The versions with dots are used on Unix, and the versions without
@@ -1747,22 +1744,6 @@ class PyBuildExt(build_ext):
             if dir not in include_dirs:
                 include_dirs.append(dir)

-        # Check for various platform-specific directories
-        if host_platform == 'sunos5':
-            include_dirs.append('/usr/openwin/include')
-            added_lib_dirs.append('/usr/openwin/lib')
-        elif os.path.exists('/usr/X11R6/include'):
-            include_dirs.append('/usr/X11R6/include')
-            added_lib_dirs.append('/usr/X11R6/lib64')
-            added_lib_dirs.append('/usr/X11R6/lib')
-        elif os.path.exists('/usr/X11R5/include'):
-            include_dirs.append('/usr/X11R5/include')
-            added_lib_dirs.append('/usr/X11R5/lib')
-        else:
-            # Assume default location for X11
-            include_dirs.append('/usr/X11/include')
-            added_lib_dirs.append('/usr/X11/lib')
-
         # If Cygwin, then verify that X is installed before proceeding
         if host_platform == 'cygwin':
             x11_inc = find_file('X11/Xlib.h', [], include_dirs)
@@ -1786,10 +1767,6 @@ class PyBuildExt(build_ext):
         if host_platform in ['aix3', 'aix4']:
             libs.append('ld')

-        # Finally, link with the X11 libraries (not appropriate on cygwin)
-        if host_platform != "cygwin":
-            libs.append('X11')
-
         ext = Extension('_tkinter', ['_tkinter.c', 'tkappinit.c'],
                         define_macros=[('WITH_APPINIT', 1)] + defs,
                         include_dirs = include_dirs,
