class Python < Formula
  desc "Interpreted, interactive, object-oriented programming language"
  homepage "https://www.python.org"
  url "https://www.python.org/ftp/python/2.7.12/Python-2.7.12.tar.xz"
  sha256 "d7837121dd5652a05fef807c361909d255d173280c4e1a4ded94d73d80a1f978"
  revision 2

  head "https://hg.python.org/cpython", :using => :hg, :branch => "2.7"

  bottle do
    sha256 "082e12c8a27f4d18d15340818f4b14052916880c93b0b668d23b7a87c5ffb124" => :sierra
    sha256 "a521afdafd08a7f09b48b9f36a76786671dbec1a5b8b2ae3a02f31286effee73" => :el_capitan
    sha256 "09630f52c4121f47fe3ae2bb7210a0f673c74c8d4474db5fd22be0e605fb1cab" => :yosemite
  end

  # Please don't add a wide/ucs4 option as it won't be accepted.
  # More details in: https://github.com/Homebrew/homebrew/pull/32368
  option :universal
  option "with-quicktest", "Run `make quicktest` after the build (for devs; may fail)"
  option "with-tcl-tk", "Use Homebrew's Tk instead of OS X Tk (has optional Cocoa and threads support)"
  option "with-poll", "Enable select.poll, which is not fully implemented on OS X (https://bugs.python.org/issue5154)"

  # sphinx-doc depends on python, but on 10.6 or earlier python is fulfilled by
  # brew, which would lead to circular dependency.
  if MacOS.version > :snow_leopard
    option "with-sphinx-doc", "Build HTML documentation"
    depends_on "sphinx-doc" => [:build, :optional]
  end

  deprecated_option "quicktest" => "with-quicktest"
  deprecated_option "with-brewed-tk" => "with-tcl-tk"

  depends_on "pkg-config" => :build
  depends_on "readline" => :recommended
  depends_on "sqlite" => :recommended
  depends_on "gdbm" => :recommended
  depends_on "openssl"
  depends_on "homebrew/dupes/tcl-tk" => :optional
  depends_on "berkeley-db4" => :optional
  depends_on :x11 if build.with?("tcl-tk") && Tab.for_name("homebrew/dupes/tcl-tk").with?("x11")

  skip_clean "bin/pip", "bin/pip-2.7"
  skip_clean "bin/easy_install", "bin/easy_install-2.7"

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/9f/7c/0a33c528164f1b7ff8cf0684cf88c2e733c8ae0119ceca4a3955c7fc059d/setuptools-23.1.0.tar.gz"
    sha256 "4e269d36ba2313e6236f384b36eb97b3433cf99a16b94c74cca7eee2b311f2be"
  end

  resource "pip" do
    url "https://files.pythonhosted.org/packages/e7/a8/7556133689add8d1a54c0b14aeff0acb03c64707ce100ecd53934da1aa13/pip-8.1.2.tar.gz"
    sha256 "4d24b03ffa67638a3fa931c09fd9e0273ffa904e95ebebe7d4b1a54c93d7b732"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/c9/1d/bd19e691fd4cfe908c76c429fe6e4436c9e83583c4414b54f6c85471954a/wheel-0.29.0.tar.gz"
    sha256 "1ebb8ad7e26b448e9caa4773d2357849bf80ff9e313964bcaf79cbf0201a1648"
  end

  # Patch to disable the search for Tk.framework, since Homebrew's Tk is
  # a plain unix build. Remove `-lX11`, too because our Tk is "AquaTk".
  patch :DATA if build.with? "tcl-tk"

  # Patch for pyport.h macro issue
  # https://bugs.python.org/issue10910
  # https://trac.macports.org/ticket/44288
  patch do
    url "https://bugs.python.org/file30805/issue10910-workaround.txt"
    sha256 "c075353337f9ff3ccf8091693d278782fcdff62c113245d8de43c5c7acc57daf"
  end

  # Patch for building universal binaries on macOS 10.12 and 10.11 with Xcode 8
  # https://bugs.python.org/issue27806
  if build.universal? && DevelopmentTools.clang_build_version >= 800
    patch do
      url "https://hg.python.org/cpython/raw-rev/4030300fcb18"
      sha256 "e0625b20675d892abc3e0e9a58a4627b94e6ded017f352f55b7c91e214fbd248"
    end
  end

  def lib_cellar
    prefix/"Frameworks/Python.framework/Versions/2.7/lib/python2.7"
  end

  def site_packages_cellar
    lib_cellar/"site-packages"
  end

  # The HOMEBREW_PREFIX location of site-packages.
  def site_packages
    HOMEBREW_PREFIX/"lib/python2.7/site-packages"
  end

  # setuptools remembers the build flags python is built with and uses them to
  # build packages later. Xcode-only systems need different flags.
  pour_bottle? do
    reason <<-EOS.undent
    The bottle needs the Apple Command Line Tools to be installed.
      You can install them, if desired, with:
        xcode-select --install
    EOS
    satisfy { MacOS::CLT.installed? }
  end

  def install
    ENV.permit_weak_imports

    if build.with? "poll"
      opoo "The given option --with-poll enables a somewhat broken poll() on OS X (https://bugs.python.org/issue5154)."
    end

    # Unset these so that installing pip and setuptools puts them where we want
    # and not into some other Python the user has installed.
    ENV["PYTHONHOME"] = nil
    ENV["PYTHONPATH"] = nil

    args = %W[
      --prefix=#{prefix}
      --enable-ipv6
      --datarootdir=#{share}
      --datadir=#{share}
      --enable-framework=#{frameworks}
      --without-ensurepip
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

    # Avoid linking to libgcc https://code.activestate.com/lists/python-dev/112195/
    args << "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"

    # We want our readline and openssl! This is just to outsmart the detection code,
    # superenv handles that cc finds includes/libs!
    inreplace "setup.py" do |s|
      s.gsub! "do_readline = self.compiler.find_library_file(lib_dirs, 'readline')",
              "do_readline = '#{Formula["readline"].opt_lib}/libhistory.dylib'"
      s.gsub! "/usr/local/ssl", Formula["openssl"].opt_prefix
      s.gsub! "/usr/include/db4", Formula["berkeley-db4"].opt_include
    end

    if build.universal?
      ENV.universal_binary
      args << "--enable-universalsdk=/" << "--with-universal-archs=intel"
    end

    if build.with? "sqlite"
      inreplace "setup.py" do |s|
        s.gsub! "sqlite_setup_debug = False", "sqlite_setup_debug = True"
        s.gsub! "for d_ in inc_dirs + sqlite_inc_paths:",
                "for d_ in ['#{Formula["sqlite"].opt_include}']:"

        # Allow sqlite3 module to load extensions:
        # https://docs.python.org/library/sqlite3.html#f1
        s.gsub! 'sqlite_defines.append(("SQLITE_OMIT_LOAD_EXTENSION", "1"))', ""
      end
    end

    # Allow python modules to use ctypes.find_library to find homebrew's stuff
    # even if homebrew is not a /usr/local/lib. Try this with:
    # `brew install enchant && pip install pyenchant`
    inreplace "./Lib/ctypes/macholib/dyld.py" do |f|
      f.gsub! "DEFAULT_LIBRARY_FALLBACK = [", "DEFAULT_LIBRARY_FALLBACK = [ '#{HOMEBREW_PREFIX}/lib',"
      f.gsub! "DEFAULT_FRAMEWORK_FALLBACK = [", "DEFAULT_FRAMEWORK_FALLBACK = [ '#{HOMEBREW_PREFIX}/Frameworks',"
    end

    if build.with? "tcl-tk"
      tcl_tk = Formula["homebrew/dupes/tcl-tk"].opt_prefix
      cppflags << "-I#{tcl_tk}/include"
      ldflags  << "-L#{tcl_tk}/lib"
    end

    args << "CFLAGS=#{cflags.join(" ")}" unless cflags.empty?
    args << "LDFLAGS=#{ldflags.join(" ")}" unless ldflags.empty?
    args << "CPPFLAGS=#{cppflags.join(" ")}" unless cppflags.empty?

    system "./configure", *args

    # HAVE_POLL is "broken" on OS X. See:
    # https://trac.macports.org/ticket/18376
    # https://bugs.python.org/issue5154
    if build.without? "poll"
      inreplace "pyconfig.h", /.*?(HAVE_POLL[_A-Z]*).*/, '#undef \1'
    end

    system "make"
    if build.with?("quicktest") || build.bottle?
      system "make", "quicktest", "TESTPYTHONOPTS=-s", "TESTOPTS=-j#{ENV.make_jobs} -w"
    end

    ENV.deparallelize do
      # Tell Python not to install into /Applications
      system "make", "install", "PYTHONAPPSDIR=#{prefix}"
      system "make", "frameworkinstallextras", "PYTHONAPPSDIR=#{pkgshare}"
    end

    # Fixes setting Python build flags for certain software
    # See: https://github.com/Homebrew/homebrew/pull/20182
    # https://bugs.python.org/issue3588
    inreplace lib_cellar/"config/Makefile" do |s|
      s.change_make_var! "LINKFORSHARED",
        "-u _PyMac_Error $(PYTHONFRAMEWORKINSTALLDIR)/Versions/$(VERSION)/$(PYTHONFRAMEWORK)"
    end

    # Prevent third-party packages from building against fragile Cellar paths
    inreplace [lib_cellar/"_sysconfigdata.py",
               lib_cellar/"config/Makefile",
               frameworks/"Python.framework/Versions/Current/lib/pkgconfig/python-2.7.pc"],
              prefix, opt_prefix

    # Symlink the pkgconfig files into HOMEBREW_PREFIX so they're accessible.
    (lib/"pkgconfig").install_symlink Dir[frameworks/"Python.framework/Versions/Current/lib/pkgconfig/*"]

    # Remove the site-packages that Python created in its Cellar.
    site_packages_cellar.rmtree

    (libexec/"setuptools").install resource("setuptools")
    (libexec/"pip").install resource("pip")
    (libexec/"wheel").install resource("wheel")

    if MacOS.version > :snow_leopard && build.with?("sphinx-doc")
      cd "Doc" do
        system "make", "html"
        doc.install Dir["build/html/*"]
      end
    end
  end

  def post_install
    # Fix up the site-packages so that user-installed Python software survives
    # minor updates, such as going from 2.7.0 to 2.7.1:

    # Create a site-packages in HOMEBREW_PREFIX/lib/python2.7/site-packages
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
    # setuptools-0.9.5-py3.3.egg
    rm_rf Dir["#{site_packages}/setuptools*"]
    rm_rf Dir["#{site_packages}/distribute*"]
    rm_rf Dir["#{site_packages}/pip[-_.][0-9]*", "#{site_packages}/pip"]

    setup_args = ["-s", "setup.py", "--no-user-cfg", "install", "--force",
                  "--verbose",
                  "--single-version-externally-managed",
                  "--record=installed.txt",
                  "--install-scripts=#{bin}",
                  "--install-lib=#{site_packages}"]

    (libexec/"setuptools").cd { system "#{bin}/python", *setup_args }
    (libexec/"pip").cd { system "#{bin}/python", *setup_args }
    (libexec/"wheel").cd { system "#{bin}/python", *setup_args }

    # When building from source, these symlinks will not exist, since
    # post_install happens after linking.
    %w[pip pip2 pip2.7 easy_install easy_install-2.7 wheel].each do |e|
      (HOMEBREW_PREFIX/"bin").install_symlink bin/e
    end

    # Help distutils find brewed stuff when building extensions
    include_dirs = [HOMEBREW_PREFIX/"include", Formula["openssl"].opt_include]
    library_dirs = [HOMEBREW_PREFIX/"lib", Formula["openssl"].opt_lib]

    if build.with? "sqlite"
      include_dirs << Formula["sqlite"].opt_include
      library_dirs << Formula["sqlite"].opt_lib
    end

    if build.with? "tcl-tk"
      include_dirs << Formula["homebrew/dupes/tcl-tk"].opt_include
      library_dirs << Formula["homebrew/dupes/tcl-tk"].opt_lib
    end

    cfg = lib_cellar/"distutils/distutils.cfg"
    cfg.atomic_write <<-EOF.undent
      [install]
      prefix=#{HOMEBREW_PREFIX}

      [build_ext]
      include_dirs=#{include_dirs.join ":"}
      library_dirs=#{library_dirs.join ":"}
    EOF
  end

  def sitecustomize
    <<-EOF.undent
      # This file is created by Homebrew and is executed on each python startup.
      # Don't print from here, or else python command line scripts may fail!
      # <https://github.com/Homebrew/brew/blob/master/docs/Homebrew-and-Python.md>
      import re
      import os
      import sys

      if sys.version_info[0] != 2:
          # This can only happen if the user has set the PYTHONPATH for 3.x and run Python 2.x or vice versa.
          # Every Python looks at the PYTHONPATH variable and we can't fix it here in sitecustomize.py,
          # because the PYTHONPATH is evaluated after the sitecustomize.py. Many modules (e.g. PyQt4) are
          # built only for a specific version of Python and will fail with cryptic error messages.
          # In the end this means: Don't set the PYTHONPATH permanently if you use different Python versions.
          exit('Your PYTHONPATH points to a site-packages dir for Python 2.x but you are running Python ' +
               str(sys.version_info[0]) + '.x!\\n     PYTHONPATH is currently: "' + str(os.environ['PYTHONPATH']) + '"\\n' +
               '     You should `unset PYTHONPATH` to fix this.')

      # Only do this for a brewed python:
      if os.path.realpath(sys.executable).startswith('#{rack}'):
          # Shuffle /Library site-packages to the end of sys.path and reject
          # paths in /System pre-emptively (#14712)
          library_site = '/Library/Python/2.7/site-packages'
          library_packages = [p for p in sys.path if p.startswith(library_site)]
          sys.path = [p for p in sys.path if not p.startswith(library_site) and
                                             not p.startswith('/System')]
          # .pth files have already been processed so don't use addsitedir
          sys.path.extend(library_packages)

          # the Cellar site-packages is a symlink to the HOMEBREW_PREFIX
          # site_packages; prefer the shorter paths
          long_prefix = re.compile(r'#{rack}/[0-9\._abrc]+/Frameworks/Python\.framework/Versions/2\.7/lib/python2\.7/site-packages')
          sys.path = [long_prefix.sub('#{site_packages}', p) for p in sys.path]

          # LINKFORSHARED (and python-config --ldflags) return the
          # full path to the lib (yes, "Python" is actually the lib, not a
          # dir) so that third-party software does not need to add the
          # -F/#{HOMEBREW_PREFIX}/Frameworks switch.
          try:
              from _sysconfigdata import build_time_vars
              build_time_vars['LINKFORSHARED'] = '-u _PyMac_Error #{opt_prefix}/Frameworks/Python.framework/Versions/2.7/Python'
          except:
              pass  # remember: don't print here. Better to fail silently.

          # Set the sys.executable to use the opt_prefix
          sys.executable = '#{opt_bin}/python2.7'
    EOF
  end

  def caveats; <<-EOS.undent
    Pip and setuptools have been installed. To update them
      pip install --upgrade pip setuptools

    You can install Python packages with
      pip install <package>

    They will install into the site-package directory
      #{site_packages}

    See: https://github.com/Homebrew/brew/blob/master/docs/Homebrew-and-Python.md
    EOS
  end

  test do
    # Check if sqlite is ok, because we build with --enable-loadable-sqlite-extensions
    # and it can occur that building sqlite silently fails if OSX's sqlite is used.
    system "#{bin}/python", "-c", "import sqlite3"
    # Check if some other modules import. Then the linked libs are working.
    system "#{bin}/python", "-c", "import Tkinter; root = Tkinter.Tk()"
    system bin/"pip", "list"
  end
end

__END__
diff --git a/setup.py b/setup.py
index 716f08e..66114ef 100644
--- a/setup.py
+++ b/setup.py
@@ -1810,9 +1810,6 @@ class PyBuildExt(build_ext):
         # Rather than complicate the code below, detecting and building
         # AquaTk is a separate method. Only one Tkinter will be built on
         # Darwin - either AquaTk, if it is found, or X11 based Tk.
-        if (host_platform == 'darwin' and
-            self.detect_tkinter_darwin(inc_dirs, lib_dirs)):
-            return

         # Assume we haven't found any of the libraries or include files
         # The versions with dots are used on Unix, and the versions without
@@ -1858,21 +1855,6 @@ class PyBuildExt(build_ext):
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

         # If Cygwin, then verify that X is installed before proceeding
         if host_platform == 'cygwin':
@@ -1897,9 +1879,6 @@ class PyBuildExt(build_ext):
         if host_platform in ['aix3', 'aix4']:
             libs.append('ld')

-        # Finally, link with the X11 libraries (not appropriate on cygwin)
-        if host_platform != "cygwin":
-            libs.append('X11')

         ext = Extension('_tkinter', ['_tkinter.c', 'tkappinit.c'],
                         define_macros=[('WITH_APPINIT', 1)] + defs,
