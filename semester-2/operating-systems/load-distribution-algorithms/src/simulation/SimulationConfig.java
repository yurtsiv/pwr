package simulation;

public class SimulationConfig {
    public int p, r, z, n;

    public SimulationConfig(int p, int r, int z, int n) {
        validateArgs(p, r, z, n);

        this.p = p;
        this.r = r;
        this.z = z;
        this.n = n;
    }

    private static void validateArgs(int p, int r, int z, int n) {
        if (n <= 0) {
            throw new IllegalArgumentException("Parameter 'n' is illegal");
        }
        if (p <= 0 || p > 100) {
            throw new IllegalArgumentException("Parameter 'p' is illegal");
        }
        if (r >= p || r <= 0 || r > 100) {
            throw new IllegalArgumentException("Parameter 'r' is illegal");
        }
        if (z > n) {
            throw new IllegalArgumentException("Parameter 'z' is illegal");
        }
    }
}
