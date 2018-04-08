class Hashpump < Formula
  desc "Tool to exploit hash length extension attack"
  homepage "https://github.com/bwall/HashPump"
  url "https://github.com/bwall/HashPump/archive/v1.2.0.tar.gz"
  sha256 "d002e24541c6604e5243e5325ef152e65f9fcd00168a9fa7a06ad130e28b811b"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "024b5b706f5eb95ababc1f6f33f92ba8dce52053dae3f762851edc1573ce6408" => :high_sierra
    sha256 "3be6e3a2038bb6798f3c8a44e7b9cf6c097a1d5f39c39c932487df576f5cf571" => :sierra
    sha256 "ae2d8b1f802b8243665ddf8eef75f73a288759231b16b49fb66bd84bf945ee2b" => :el_capitan
  end

  option "without-python@2", "Build without python 2 support"

  deprecated_option "with-python3" => "with-python"
  deprecated_option "without-python" => "without-python@2"

  depends_on "openssl"
  depends_on "python@2" => :recommended
  depends_on "python" => :optional

  # Remove on next release
  patch do
    url "https://github.com/bwall/HashPump/pull/14.patch?full_index=1"
    sha256 "ffc978cbc07521796c0738df77a3e40d79de0875156f9440ef63eca06b2e2779"
  end

  def install
    bin.mkpath
    system "make", "INSTALLLOCATION=#{bin}",
                   "CXX=#{ENV.cxx}",
                   "install"

    Language::Python.each_python(build) do |python, _version|
      system python, *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    output = `#{bin}/hashpump -s '6d5f807e23db210bc254a28be2d6759a0f5f5d99' \\
      -d 'count=10&lat=37.351&user_id=1&long=-119.827&waffle=eggo' \\
      -a '&waffle=liege' -k 14`
    assert_match /0e41270260895979317fff3898ab85668953aaa2/, output
    assert_match /&waffle=liege/, output
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
