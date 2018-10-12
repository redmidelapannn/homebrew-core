class Op < Formula
  desc "1Password CLI"
  homepage "https://app-updates.agilebits.com/product_history/CLI"
  url "https://cache.agilebits.com/dist/1P/op/pkg/v0.5.4/op_darwin_amd64_v0.5.4.zip"
  sha256 "93c8bae059e784fc2409c07e09b53648bd449feca3af1bfec4260e9ae9648830"

  bottle do
    cellar :any_skip_relocation
    sha256 "b44f52b5575abc6c99ca777ba24df4233c56fe8c98be1522e93eb5a4e8ca57bc" => :mojave
    sha256 "fce496d834939a9fa2695e182d495f42585a2eb06eec2c1d01f72498e5a8e90e" => :high_sierra
    sha256 "fce496d834939a9fa2695e182d495f42585a2eb06eec2c1d01f72498e5a8e90e" => :sierra
  end

  def install
    bin.install "op"
  end

  test do
    system bin/"op", "--version"
  end
end
