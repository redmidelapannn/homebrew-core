class Nlopt < Formula
  desc "Free/open-source library for nonlinear optimization"
  homepage "https://nlopt.readthedocs.io/"
  url "https://github.com/stevengj/nlopt/releases/download/nlopt-2.4.2/nlopt-2.4.2.tar.gz"
  sha256 "8099633de9d71cbc06cd435da993eb424bbcdbded8f803cdaa9fb8c6e09c8e89"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "2120b2e8f3538c90efeb77125d4ac146f5c945ad89ca183a797cc1f52197e381" => :high_sierra
    sha256 "1a453cc5c21e0f34bdbecdcf74faae6cdc8ab82ad7163c1fc0c5bbef2e928778" => :sierra
    sha256 "befc7d1b9223613a9496ccdb0b39a97c15d9c1c8c9455cd544eb0bcc37d41c4f" => :el_capitan
  end

  head do
    url "https://github.com/stevengj/nlopt.git"
    depends_on "cmake" => :build
    depends_on "swig" => :build
  end

  depends_on "numpy" => :recommended

  def install
    ENV.deparallelize

    if build.head?
      system "cmake", ".", *std_cmake_args,
                      "-DBUILD_MATLAB=OFF",
                      "-DBUILD_OCTAVE=OFF",
                      "-DWITH_CXX=ON"
    else
      system "./configure", "--prefix=#{prefix}",
                            "--enable-shared",
                            "--with-cxx",
                            "--without-octave"
      system "make"
    end
    system "make", "install"

    # Create library links for C programs
    %w[0.dylib dylib a].each do |suffix|
      lib.install_symlink "#{lib}/libnlopt_cxx.#{suffix}" => "#{lib}/libnlopt.#{suffix}"
    end
  end

  test do
    # Based on http://ab-initio.mit.edu/wiki/index.php/NLopt_Tutorial#Example_in_C.2FC.2B.2B
    (testpath/"test.c").write <<~EOS
      #include <math.h>
      #include <nlopt.h>
      #include <stdio.h>
      double myfunc(unsigned n, const double *x, double *grad, void *my_func_data) {
        if (grad) {
          grad[0] = 0.0;
          grad[1] = 0.5 / sqrt(x[1]);
        }
        return sqrt(x[1]);
      }
      typedef struct { double a, b; } my_constraint_data;
      double myconstraint(unsigned n, const double *x, double *grad, void *data) {
        my_constraint_data *d = (my_constraint_data *) data;
        double a = d->a, b = d->b;
        if (grad) {
          grad[0] = 3 * a * (a*x[0] + b) * (a*x[0] + b);
          grad[1] = -1.0;
        }
        return ((a*x[0] + b) * (a*x[0] + b) * (a*x[0] + b) - x[1]);
       }
       int main() {
        double lb[2] = { -HUGE_VAL, 0 }; /* lower bounds */
        nlopt_opt opt;
        opt = nlopt_create(NLOPT_LD_MMA, 2); /* algorithm and dimensionality */
        nlopt_set_lower_bounds(opt, lb);
        nlopt_set_min_objective(opt, myfunc, NULL);
        my_constraint_data data[2] = { {2,0}, {-1,1} };
        nlopt_add_inequality_constraint(opt, myconstraint, &data[0], 1e-8);
        nlopt_add_inequality_constraint(opt, myconstraint, &data[1], 1e-8);
        nlopt_set_xtol_rel(opt, 1e-4);
        double x[2] = { 1.234, 5.678 };  /* some initial guess */
        double minf; /* the minimum objective value, upon return */

        if (nlopt_optimize(opt, x, &minf) < 0)
          return 1;
        else
          printf("found minimum at f(%g,%g) = %0.10g", x[0], x[1], minf);
        nlopt_destroy(opt);
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-lnlopt", "-lm"
    assert_match "found minimum", shell_output("./test")
  end
end
