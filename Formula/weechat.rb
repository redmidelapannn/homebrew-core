class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-1.5.tar.gz"
  sha256 "3174558556a20ae8f9ee3abbf66b7d42b657d3370322555501a707e339e10771"

  head "https://github.com/weechat/weechat.git"

  bottle do
    rebuild 1
    sha256 "626590163c3907236f5e6b7ab893144e8289435c9ced3eca6eb08ae7fd1ae4b3" => :el_capitan
    sha256 "0b30d902f1b390e01db5e34ab77ee38f212964f3b3da5857e119365c93930fdb" => :yosemite
    sha256 "6f2296116addf9b614b7e3ca203c9f9d98f26872b21b842b0a1ac9812c52dc15" => :mavericks
  end

  option "with-perl", "Build the perl module"
  option "with-ruby", "Build the ruby module"
  option "with-curl", "Build with brewed curl"
  option "with-debug", "Build with debug information"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "gettext"
  depends_on "guile" => :optional
  depends_on "aspell" => :optional
  depends_on "lua" => :optional
  depends_on :python => :optional
  depends_on "curl" => :optional

  def install
    # Get around res_init() errors on 10.11
    ENV.append "LDFLAGS", "-lresolv"

    args = std_cmake_args
    if build.with? "debug"
      args -= %w[-DCMAKE_BUILD_TYPE=Release]
      args << "-DCMAKE_BUILD_TYPE=Debug"
    end

    args << "-DENABLE_LUA=OFF" if build.without? "lua"
    args << "-DENABLE_PERL=OFF" if build.without? "perl"
    args << "-DENABLE_RUBY=OFF" if build.without? "ruby"
    args << "-DENABLE_ASPELL=OFF" if build.without? "aspell"
    args << "-DENABLE_GUILE=OFF" if build.without? "guile"
    args << "-DENABLE_PYTHON=OFF" if build.without? "python"
    args << "-DENABLE_JAVASCRIPT=OFF"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install", "VERBOSE=1"
    end
  end

  def caveats; <<-EOS.undent
      Weechat can depend on Aspell if you choose the --with-aspell option, but
      Aspell should be installed manually before installing Weechat so that
      you can choose the dictionaries you want.  If Aspell was installed
      automatically as part of weechat, there won't be any dictionaries.
    EOS
  end

  test do
    ENV["TERM"] = "xterm"
    system "weechat", "-r", "/quit"
  end
end
