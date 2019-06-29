class JohnJumbo < Formula
  desc "Enhanced version of john, a UNIX password cracker"
  homepage "https://www.openwall.com/john/"
  url "https://www.openwall.com/john/k/john-1.9.0-jumbo-1.tar.xz"
  version "1.9.0"
  sha256 "f5d123f82983c53d8cc598e174394b074be7a77756f5fb5ed8515918c81e7f3b"

  bottle do
    cellar :any
    sha256 "ee1cd07d29b79344fd0888987aeb52300ea0769b27405b0569c3de7964885156" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "openssl"

  conflicts_with "john", :because => "both install the same binaries"

  def install
    cd "src" do
      system "./configure", "--disable-native-tests", "--disable-native-march"
      system "make", "clean"
      system "make", "-s", "CC=#{ENV.cc}"
    end

    doc.install Dir["doc/*"]

    # Only symlink the main binary into bin
    (share/"john").install Dir["run/*"]
    bin.install_symlink share/"john/john"

    bash_completion.install share/"john/john.bash_completion" => "john.bash"
    zsh_completion.install share/"john/john.zsh_completion" => "_john"
  end

  test do
    touch "john2.pot"
    (testpath/"test").write "dave:#{`printf secret | /usr/bin/openssl md5`}"
    assert_match(/secret/, shell_output("#{bin}/john --pot=#{testpath}/john2.pot --format=raw-md5 test"))
    assert_match(/secret/, (testpath/"john2.pot").read)
  end
end
