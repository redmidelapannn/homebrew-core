class Leiningen < Formula
  desc "Build tool for Clojure"
  homepage "https://github.com/technomancy/leiningen"
  url "https://github.com/technomancy/leiningen/archive/2.9.1.tar.gz"
  sha256 "a4c239b407576f94e2fef5bfa107f0d3f97d0b19c253b08860d9609df4ab8b29"
  revision 1
  head "https://github.com/technomancy/leiningen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "477ec513b7a1d4ec147624f7cef5a2de1d153756e6784c939f6a6b161f2ee313" => :catalina
    sha256 "477ec513b7a1d4ec147624f7cef5a2de1d153756e6784c939f6a6b161f2ee313" => :mojave
    sha256 "477ec513b7a1d4ec147624f7cef5a2de1d153756e6784c939f6a6b161f2ee313" => :high_sierra
  end

  depends_on "openjdk@11"

  resource "jar" do
    url "https://github.com/technomancy/leiningen/releases/download/2.9.1/leiningen-2.9.1-standalone.zip", :using => :nounzip
    sha256 "ea7c831a4f5c38b6fc3926c6ad32d1d4b9b91bf830a715ecff5a70a18bda55f8"
  end

  def install
    jar = "leiningen-#{version}-standalone.jar"
    resource("jar").stage do
      libexec.install "leiningen-#{version}-standalone.zip" => jar
    end

    # bin/lein autoinstalls and autoupdates, which doesn't work too well for us
    inreplace "bin/lein-pkg" do |s|
      s.change_make_var! "LEIN_JAR", libexec/jar
    end

    chmod "+x", "bin/lein-pkg"
    (libexec/"bin").install "bin/lein-pkg"
    (bin/"lein").write_env_script libexec/"bin/lein-pkg", :JAVA_HOME => "${JAVA_HOME:-#{Formula["openjdk@11"].opt_prefix}}"
    bash_completion.install "bash_completion.bash" => "lein-completion.bash"
    zsh_completion.install "zsh_completion.zsh" => "_lein"
  end

  def caveats; <<~EOS
    Dependencies will be installed to:
      $HOME/.m2/repository
    To play around with Clojure run `lein repl` or `lein help`.
  EOS
  end

  test do
    (testpath/"project.clj").write <<~EOS
      (defproject brew-test "1.0"
        :dependencies [[org.clojure/clojure "1.5.1"]])
    EOS
    (testpath/"src/brew_test/core.clj").write <<~EOS
      (ns brew-test.core)
      (defn adds-two
        "I add two to a number"
        [x]
        (+ x 2))
    EOS
    (testpath/"test/brew_test/core_test.clj").write <<~EOS
      (ns brew-test.core-test
        (:require [clojure.test :refer :all]
                  [brew-test.core :as t]))
      (deftest canary-test
        (testing "adds-two yields 4 for input of 2"
          (is (= 4 (t/adds-two 2)))))
    EOS
    system "#{bin}/lein", "test"
  end
end
