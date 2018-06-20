class Buildcannon < Formula
  desc "buildcannon is a automation buildtool for iOS"
  homepage "https://github.com/andersonlucasg3/buildcannon"
  url "https://github.com/andersonlucasg3/buildcannon/releases/download/0.2.1/buildcannon.zip"
  sha256 "5019dd36b439037355f8105915d135b0a5bb1071801ddd55bd0d8459ac0d27b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "250818dcf6bc9a93315864bc2fb383fe7a49f57fae9b8f1bb229594be753d806" => :high_sierra
    sha256 "250818dcf6bc9a93315864bc2fb383fe7a49f57fae9b8f1bb229594be753d806" => :sierra
    sha256 "250818dcf6bc9a93315864bc2fb383fe7a49f57fae9b8f1bb229594be753d806" => :el_capitan
  end

  def install
    bin.install "buildcannon"
  end

  test do
    system "#{bin}/buildcannon", "--help"
  end
end
