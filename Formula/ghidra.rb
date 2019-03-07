class Ghidra < Formula
  desc "Software reverse engineering framework"
  homepage "https://ghidra-sre.org/"
  url "https://ghidra-sre.org/ghidra_9.0_PUBLIC_20190228.zip"
  version "9.0"
  sha256 "3b65d29024b9decdbb1148b12fe87bcb7f3a6a56ff38475f5dc9dd1cfc7fd6b2"
  bottle do
    cellar :any_skip_relocation
    sha256 "8a3b65b5f3b3b0a09f58d6a79eb9284dd15c9f5f6f845d36d1824bf650c74919" => :mojave
    sha256 "8a3b65b5f3b3b0a09f58d6a79eb9284dd15c9f5f6f845d36d1824bf650c74919" => :high_sierra
    sha256 "06042e5da4324afb378b60182a64add002ffd0bdefc635481b6762c11d98f16d" => :sierra
  end

  depends_on :java => "11.0+"

  def install
    rm Dir["support/*.bat"]
    rm Dir["server/*.bat"]
    rm Dir["*.bat"]
    prefix.install Dir["*"]
    (bin/"ghidra").write_env_script(prefix/"ghidraRun", Language::Java.java_home_env("11"))
  end

  test do
    (testpath/"project").mkpath
    mkdir("#{HOMEBREW_CACHE}/java_cache")
    system "#{prefix}/support/analyzeHeadless", "#{testpath}/project", "HomebrewTest", "-import", "/bin/bash", "-noanalysis"
    assert_predicate (testpath/"project/HomebrewTest.rep"), :exist?
  end
end
