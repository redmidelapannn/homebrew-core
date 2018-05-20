class Ceu < Formula
  desc "Reactive language alternative to C"
  homepage "http://www.ceu-lang.org/"
  url "https://github.com/fsantanna/ceu.git", :tag => "v0.30"
  bottle do
    cellar :any_skip_relocation
    sha256 "ccb47980cdee7bbe4cb67cb84389f8615a691288f47a121c181da8781335169e" => :high_sierra
    sha256 "a772ab2fd8d31743084c7b6f8b4596d4f0fcedc86b12685ccfa96334939435d9" => :sierra
    sha256 "dab3da338cd203d6b3623ecd929eb70dfd955bd78a320ca4590527f30e672cd8" => :el_capitan
  end

  depends_on "lua"

  resource "lpeg" do
    url "https://luarocks.org/manifests/gvvaughan/lpeg-1.0.1-1.src.rock", :using => :nounzip
    sha256 "149be31e0155c4694f77ea7264d9b398dd134eca0d00ff03358d91a6cfb2ea9d"
  end

  def install
    luapath = libexec/"vendor"
    ENV["LUA_PATH"] = "#{luapath}/share/lua/5.3/?.lua"
    ENV["LUA_CPATH"] = "#{luapath}/lib/lua/5.3/?.so"

    resource("lpeg").stage do
      system "luarocks", "build", "lpeg", "--tree=#{luapath}"
    end

    system "make"
    bin.install "src/lua/ceu"

    env = { :LUA_PATH => ENV["LUA_PATH"], :LUA_CPATH => ENV["LUA_CPATH"] }
    bin.env_script_all_files(libexec/"bin", env)
  end

  test do
    system "#{bin}/ceu", "--version"
  end
end
