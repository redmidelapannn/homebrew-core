class Vis < Formula
  desc "Vim-like text editor"
  homepage "https://github.com/martanne/vis"
  url "https://github.com/martanne/vis/archive/v0.5.tar.gz"
  sha256 "77ea70ebc9c811d88e32199ef5b3ee9b834ac1e880fb61b6d2460f93f0587df5"
  head "https://github.com/martanne/vis.git"

  bottle do
    rebuild 1
    sha256 "074351f3edfbcfef9a7d79363aa3398d2ebe8ea8770916e965080602e9fc5db5" => :high_sierra
    sha256 "74fdf3333a04c7d770d7fa808e8e3a2f6b4e92565e3185fd71c4f8dc2023db5a" => :sierra
    sha256 "72438b32b36c05ed27f9cc0d479053892ce1b7d9d873b7c856e0e49428e31fb3" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libtermkey"
  depends_on "lua"

  resource "lpeg" do
    url "https://luarocks.org/manifests/gvvaughan/lpeg-1.0.1-1.src.rock"
    sha256 "149be31e0155c4694f77ea7264d9b398dd134eca0d00ff03358d91a6cfb2ea9d"
  end

  def install
    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "#{luapath}/share/lua/5.3/?.lua"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/5.3/?.so"

    resource("lpeg").stage do
      system "luarocks", "build", "lpeg", "--tree=#{luapath}"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    env = { :LUA_PATH => ENV["LUA_PATH"], :LUA_CPATH => ENV["LUA_CPATH"] }
    bin.env_script_all_files(libexec/"bin", env)
    # Rename vis & the matching manpage to avoid clashing with the system.
    mv bin/"vis", bin/"vise"
    mv man1/"vis.1", man1/"vise.1"
  end

  def caveats; <<~EOS
    To avoid a name conflict with the macOS system utility /usr/bin/vis,
    this text editor must be invoked by calling `vise` ("vis-editor").
  EOS
  end

  test do
    assert_match "vis v#{version} +curses +lua", shell_output("#{bin}/vise -v 2>&1")
  end
end
