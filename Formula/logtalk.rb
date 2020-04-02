class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3370stable.tar.gz"
  version "3.37.0"
  sha256 "55261e2ce806eb7112b27abf8cf72a2cd4deac9f011aaab8e2304d63407ea50c"

  bottle do
    cellar :any_skip_relocation
    sha256 "629740933481f4c167b0d727a535ccac9ddc2b27ab2c44cb5d1fbca9d12648dc" => :catalina
    sha256 "9964345676ec8ac06e14a91109d4882941d1b857b6f018a73253d39df540a842" => :mojave
    sha256 "2ac3d69a706c033950919a875318280456d172c54fdaf17d1d1202a799233f23" => :high_sierra
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
