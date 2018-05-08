class Kotlinreplacesupporter < Formula
  desc "This is a tool of replacing"
  homepage "https://github.com/youmitsu/KotlinReplaceSupporter"
  url "https://github.com/youmitsu/KotlinReplaceSupporter/releases/download/1.0/kotlin_replace_supporter-1.0.jar"
  sha256 "f7b5feafaea72057235809f6d587539863eb6f5785fa044ff42f891ef91d55e6"
  bottle do
    cellar :any_skip_relocation
    sha256 "bcaaadbfe641852130c212b54cf604e896749daa15aea9af4852422d245f2984" => :high_sierra
    sha256 "bcaaadbfe641852130c212b54cf604e896749daa15aea9af4852422d245f2984" => :sierra
    sha256 "bcaaadbfe641852130c212b54cf604e896749daa15aea9af4852422d245f2984" => :el_capitan
  end

  depends_on :java => "1.6+"

  def install
    if build.head?
      system "./gradlew", "packJar"
      libexec.install "build/libs/kotlin_replace_supporter-1.0.jar"
    else
      libexec.install "kotlin_replace_supporter-1.0.jar"
    end
    bin.write_jar_script libexec/"kotlin_replace_supporter-1.0.jar", "krs"
  end
  test do
    system "#{bin}/krs"
  end
end
