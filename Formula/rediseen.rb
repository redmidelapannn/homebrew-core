class Rediseen < Formula
  desc "Start REST API service for Redis without writing a single line of code"
  homepage "https://github.com/XD-DENG/rediseen"
  url "https://github.com/XD-DENG/rediseen/archive/1.0.0.tar.gz"
  sha256 "50b60cdf3724ef7d4b526f5d5c9806a87d54c91010c336e398541f017a44b3f2"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d13a516d6a791302ce894e226c7cc8b5df10d4f2a7a71785bdba93dfeef16d9" => :catalina
    sha256 "fffed7fa35c5bdc7d8fe5032e5421efe46c951d9ee353539c7a783dbd8ad491d" => :mojave
    sha256 "317d0817d2a9a9f310302e01b5ef71c14d1e5c101c62cb40db1d007af72f82a7" => :high_sierra
  end

  head do
    url "https://github.com/XD-DENG/rediseen.git"
  end
  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}/#{name}"
  end

  test do
    assert_equal "1.0.0", shell_output("#{bin}/#{name} version").strip
    assert_match "[ERROR] No valid Redis URI is provided",
                 shell_output("#{bin}/#{name} start")
    assert_match "REDISEEN_DB_EXPOSED is not configured",
                 shell_output("export REDISEEN_REDIS_URI=redis://:@localhost:6379;" \
                              "#{bin}/#{name} start")
    assert_match "[ERROR] You have not specified any key pattern to allow being accessed",
                 shell_output("export REDISEEN_REDIS_URI=redis://:@localhost:6379;" \
                              "export REDISEEN_DB_EXPOSED=0;" \
                              "#{bin}/#{name} start")
    assert_match "[ERROR] Initial talking to Redis failed. Please check the URI provided.",
                 shell_output("export REDISEEN_REDIS_URI=redis://:@localhost:6379;" \
                              "export REDISEEN_DB_EXPOSED=0;" \
                              "export REDISEEN_KEY_PATTERN_EXPOSE_ALL=true;" \
                              "#{bin}/#{name} start")
  end
end
