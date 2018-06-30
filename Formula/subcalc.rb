#
# Formula for the subcalc tool
#
class Subcalc < Formula
  desc "subnet calculation and discovery tool"
  bottle do
    cellar :any_skip_relocation
    sha256 "138ea286949bfe674687e78c377fce73460c91cb04d952b8e26d30ce4e238ac0" => :high_sierra
    sha256 "74081b12b30b74803a6c87c7beb06bbe712c59ee31d0d622d0ffcd6d4d0851b4" => :sierra
    sha256 "6e03d62dbb4adf964a4dce18243b72bc76121da3ec899193006c7783dc3c2e64" => :el_capitan
  end

  homepage ""
  url "https://github.com/csjayp/subcalc/archive/v1.0.tar.gz"
  sha256 "8a9e86f9dc85cb4c59d0d85483e0a0a5affca84ad93c90de467ad5974ada5e7a"

  def install
    system "make"
    bin.install "subcalc"
  end

  test do
    system "#{bin}/subcalc", "inet", "127.0.0.1/24"
  end
end
