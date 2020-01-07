class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3340stable.tar.gz"
  version "3.34.0"
  sha256 "a56c8f2a35bea4768dfde1237bae1183edb24d688fd5d25bfc997eb5868b93bd"

  bottle do
    cellar :any_skip_relocation
    sha256 "815f9767ffd9473f7be78049a2abe34c057ad17571ab70cf3668cc2e856ab0c0" => :catalina
    sha256 "edd97ecd887f3367297760ca93a9111d24774a38b46b39f26994298074cf1bac" => :mojave
    sha256 "f204f05bde03c2685bee8fd8e590bf7c8c6e8a3f5b83cd3bff9a4ecd7017609a" => :high_sierra
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
