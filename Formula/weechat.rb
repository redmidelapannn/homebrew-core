class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  head "https://github.com/weechat/weechat.git"

  stable do
    url "https://weechat.org/files/src/weechat-2.0.1.tar.xz"
    sha256 "6943582eabbd8a6fb6dca860a86f896492cae5fceacaa396dbc9eeaa722305d1"

    # Recognise Ruby 2.5.x as valid.
    patch do
      url "https://github.com/weechat/weechat/commit/cb98f528.patch?full_index=1"
      sha256 "e9700e24606447edfbd5de15b4d9dc822454a38ed85f678b15f84b4db2323066"
    end
  end

  bottle do
    rebuild 1
    sha256 "28062d11972326ec28c987365eb02432caab5256d3172e8db092433f260f8da9" => :high_sierra
    sha256 "9bfc735b4c440cde98227b8574888744243da40c263f013216dce135544f3ade" => :sierra
    sha256 "e509c1e65a21fc84a108a06b8b1d092b9e51c3d6e68bda1a32fe6ca9061aca9b" => :el_capitan
  end

  option "with-perl", "Build the perl module"
  option "with-ruby", "Build the ruby module"
  option "with-curl", "Build with brewed curl"
  option "with-debug", "Build with debug information"
  option "without-tcl", "Do not build the tcl module"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "gettext"
  depends_on "aspell" => :optional
  depends_on "lua" => :optional
  depends_on "perl" => :optional
  depends_on "python" => :optional
  depends_on "ruby" => :optional if MacOS.version <= :sierra
  depends_on "curl" => :optional

  def install
    args = std_cmake_args + %W[
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{etc}/openssl/cert.pem
      -DENABLE_JAVASCRIPT=OFF
    ]
    if build.with? "debug"
      args -= %w[-DCMAKE_BUILD_TYPE=Release]
      args << "-DCMAKE_BUILD_TYPE=Debug"
    end

    if build.without? "ruby"
      args << "-DENABLE_RUBY=OFF"
    elsif build.with?("ruby") && MacOS.version >= :sierra
      args << "-DRUBY_EXECUTABLE=/usr/bin/ruby"
      args << "-DRUBY_LIB=/usr/lib/libruby.dylib"
    end

    args << "-DENABLE_LUA=OFF" if build.without? "lua"
    args << "-DENABLE_PERL=OFF" if build.without? "perl"
    args << "-DENABLE_ASPELL=OFF" if build.without? "aspell"
    args << "-DENABLE_TCL=OFF" if build.without? "tcl"
    args << "-DENABLE_PYTHON=OFF" if build.without? "python"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install", "VERBOSE=1"
    end
  end

  def caveats
    <<~EOS
      Weechat can depend on Aspell if you choose the --with-aspell option, but
      Aspell should be installed manually before installing Weechat so that
      you can choose the dictionaries you want.  If Aspell was installed
      automatically as part of weechat, there won't be any dictionaries.
    EOS
  end

  test do
    system "#{bin}/weechat", "-r", "/quit"
  end
end
