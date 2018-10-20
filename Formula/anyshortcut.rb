class Anyshortcut < Formula
  desc "Launch your favorite website in Terminal blaze-fastly"
  homepage "https://anyshortcut.com"
  url "https://github.com/anyshortcut/anyshortcut-cli/archive/v0.2.0.tar.gz"
  sha256 "948c9a32dded1feaf31bf811b884b0702ea2876b0267194ca4c090341427dfe1"

  bottle do
    sha256 "05151b8ef536de270e05998018f502c86bf4ce315f1e0c18d9493ba45c82cce6" => :mojave
    sha256 "a3129542175986715270dfb1e29511a393a99b2a06d770f515b647f66c03e35c" => :high_sierra
    sha256 "e4337d70d0f84eae1dbabff50f022a4c9923bea2a6034575edb226a5118b2afb" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/anyshortcut"
  end
end
