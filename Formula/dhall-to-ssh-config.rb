class DhallToSshConfig < Formula
  desc "Tool for generating an ssh config from Dhall"
  homepage "https://github.com/robertjlooby/dhall-ssh-config"
  url "https://github.com/robertjlooby/dhall-ssh-config/archive/0.1.0.0.tar.gz"
  sha256 "6cbf72f80640d56d37e6c1ddc40b9c23082b8628027004e343cb7d62321c1a82"

  bottle do
    cellar :any_skip_relocation
    sha256 "83523c43ad71aa7f4853a8683c411c2090bdd4fbec547965bdf6b29e0eb82c25" => :high_sierra
    sha256 "be2dbf50c8a7715a15186192065abf880754eb1d0d2d2b2b140097fee6c004b8" => :sierra
  end

  head do
    url "https://github.com/robertjlooby/dhall-ssh-config.git"
  end

  depends_on "haskell-stack" => :build

  def install
    system "stack", "install", "dhall-ssh-config", "--local-bin-path", bin
  end

  test do
    expected = "Host example\n     User test\n"
    actual = `echo '[{host = "example", user = Some "test"}]' | dhall-to-ssh-config`
    raise "Expected:\n#{expected} Actual:\n#{actual}" unless actual == expected
  end
end
