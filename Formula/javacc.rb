class Javacc < Formula
  desc "The most popular parser generator for use with Java applications"
  homepage "https://javacc.org/"
  url "https://github.com/javacc/javacc/archive/7.0.5.tar.gz"
  sha256 "d1502f8a7ed607de17427a1f33e490a33b0c2d5612879e812126bf95e7ed11f4"

  bottle do
    cellar :any_skip_relocation
    sha256 "bddd6aa1083daa875485e1fa612d476a68d2c8d1c1b9ba339c1c190bc29b2246" => :catalina
    sha256 "ba78c2e54814a789fe4bf2cf03bbcbc66e29326ae2b2c7b605b3f1c5ce9b6bb5" => :mojave
    sha256 "1113cb1594867773777497caf05e2183892e8d365aabeceb4d08dd8a75767b88" => :high_sierra
  end

  depends_on "ant" => :build
  depends_on :java

  def install
    system "ant"
    (libexec/"lib").install "target/javacc-#{version}.jar"
    (libexec/"docs").install Dir["docs/*"]
    (libexec/"examples").install Dir["examples/*"]
    %w[javacc jjdoc jjtree].each do |script|
      (bin/script).write <<~SH
        #!/bin/bash
        exec java -classpath #{libexec/"lib/javacc-7.0.5.jar"} #{script} "$@"
      SH
    end
  end

  test do
    src_file = libexec/"examples/SimpleExamples/Simple1.jj"

    output_file_stem = testpath/"Simple1"

    system bin/"javacc", src_file
    assert_predicate output_file_stem.sub_ext(".java"), :exist?

    system bin/"jjtree", src_file
    assert_predicate output_file_stem.sub_ext(".jj.jj"), :exist?

    system bin/"jjdoc", src_file
    assert_predicate output_file_stem.sub_ext(".html"), :exist?
  end
end
