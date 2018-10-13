class PonyStable < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/pony-stable"
  url "https://github.com/ponylang/pony-stable/archive/0.1.6.tar.gz"
  sha256 "1e980924ff7ea03e07f2eb16e5ae826ff9142f659aa83127ca80c1055af59748"
  head "https://github.com/ponylang/pony-stable.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "409b60bf0a52b3a4435eff5fb2c40acd5fae0090df9dcdae54f9648d2a037e5b" => :mojave
    sha256 "36691d34b91535f157de66eb0cc89d56c4e666991eb154f968f1e8da65d8c6b6" => :high_sierra
    sha256 "fc9a255051ae5e5f4569d6187d236d260997269cc634a26c44cb8e82cc727d43" => :sierra
  end

  depends_on "ponyc"

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test/main.pony").write <<~EOS
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    EOS
    system "#{bin}/stable", "env", "ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").chomp
  end
end
