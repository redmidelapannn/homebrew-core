class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v2.5.2.tar.gz"
  sha256 "809592cd70335e7984a16738b435e9a08071bda938b251c48258a8f946f0bdb3"

  bottle do
    cellar :any
    sha256 "39b3fcf4d4a8c5ad48a166c509cb2c693742fcdead7fe633903d241d5931541f" => :high_sierra
    sha256 "ed1611ba102557ee98197b3e94acec418244f170bdfd33d4813c64b38c5069ec" => :sierra
    sha256 "73978a4c3cf3cff4f85238e63233ea4595856c45790870787afd5e88616f778d" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libmicrohttpd"
  depends_on "libuv"

  def install
    mkdir "build" do
      system "cmake", "..", "-DUV_LIBRARY=#{Formula["libuv"].opt_lib}/libuv.a", *std_cmake_args
      system "make"
      bin.install "xmrig"
    end
    pkgshare.install "src/config.json"
  end

  test do
    require "open3"
    test_server="donotexist.localhost:65535"
    timeout=10
    Open3.popen2e("#{bin}/xmrig", "--no-color", "--max-cpu-usage=1", "--print-time=1",
                  "--threads=1", "--retries=1", "--url=#{test_server}") do |stdin, stdouts, _wait_thr|
      start_time=Time.now
      stdin.close_write

      stdouts.each do |line|
        assert (Time.now - start_time <= timeout), "No server connect after timeout"
        break if line.include? "\] \[#{test_server}\] DNS error: \"unknown node or service\""
      end
    end
  end
end
