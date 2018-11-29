class Sharecmd < Formula
  desc "Share your files with your friends using Cloudproviders with just one command."
  homepage "https://github.com/mschneider82/sharecmd"
  url "https://github.com/mschneider82/sharecmd/releases/download/v0.0.24/sharecmd_0.0.24_Darwin_x86_64.tar.gz"
  version "0.0.24"
  sha256 "f53275c9acc1c5f28b4285e3b2ce628256e0e765bc857df545451697d6e09b90"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d70d916d70ebe0f1fdd8b93794824f85d071176ccc4409284d5ae70d9f9d22c" => :mojave
    sha256 "e7686f6588badc1ce3304982fe799eade7181f5b33b198ca0802f212958150a5" => :high_sierra
    sha256 "e7686f6588badc1ce3304982fe799eade7181f5b33b198ca0802f212958150a5" => :sierra
  end

  def install
    bin.install "share"
  end
end
