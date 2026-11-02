
## MATLAB code for 2D overdamped simulations of active, adhesive cells in a bath of passive gel particles.
```matlab
fp   = 'outputs_L_50_Gam_Ecap_scan_Phi_c_0_3'; % output root folder
pfc  = 0.3;        % cell packing fraction (gel fraction = 1 - pfc)
gam  = 0:0.1:1;    % Γ values (11)
ecap = 0:0.1:1;    % ε values (11)
Ka   = 1;          % active-force relaxation rate
EgEc = 1;          % gel-to-cell stiffness ratio Eg/Ec
L    = 50;         % box side length
dim  = 2;          % spatial dimension: 2 or 3
seed = 1:10;       % random seeds (10)
```

It builds every (Γ, ε, seed) combination with `ndgrid` (11 × 11 × 10 = **1210 runs**) and calls the following for each one inside a `parfor`:

```matlab
Main(Ka, pfc, gam, ecap, EgEc, seed, fp, L, dim)
```

To change the scan, edit `gam`, `ecap`, `seed` (or `pfc`, `Ka`, `EgEc`, `L`) at the top of the script. Also change `fp` so a new scan doesn't write into an old folder.

## Running in 2D or 3D

The same code runs in both dimensions. Set `dim` in `run_simulations.m`:

```matlab
dim = 2;   % 2D: square box, positions (x, y)
dim = 3;   % 3D: cubic box, positions (x, y, z)
```

Nothing else needs to change. Positions, forces, active forces, periodic boundaries and the output files all use `dim` columns. For a 3D scan, give `fp` a name that says 3D (for example `outputs_3D_L_15_...`) so the results aren't mixed with the 2D ones.

### Particle numbers: `pack.m` switches between 2D and 3D

`pack.m` computes the number of cells and gels from the packing fractions.

```matlab
function [Nc,Ng] = pack(L,rg,rc,PFc,PFg,dim)
if dim==2
    Nc = round((PFc)*((L^2)/(pi*rc^2)));          % area fraction
    Ng = round((PFg)*((L^2)/(pi*rg^2)));
else
    Nc = round((PFc)*((L^3)/((4/3)*pi*rc^3)));    % volume fraction
    Ng = round((PFg)*((L^3)/((4/3)*pi*rg^3)));
end
end
```

| | Box | Particle | Count |
|---|---|---|---|
| 2D | area `L²` | disk area `π r²` | `N = round(φ · L² / (π r²))` |
| 3D | volume `L³` | sphere volume `(4/3) π r³` | `N = round(φ · L³ / ((4/3) π r³))` |

With `r = 0.5` (unit diameter), these become `N_c = φ_c · 4L²/π` (2D) and `N_c = φ_c · 6L³/π` (3D), the formulas used in the paper. For example, the paper's boxes with `φc = 0.3`, `φg = 0.7` give:
- **2D, L = 50:** 955 cells and 2228 gels
- **3D, L = 15:** 1934 cells and 4512 gels

## Background stiffness `EgEc`

`EgEc` is the gel-to-cell stiffness ratio Eg/Ec. It is set in `run_simulations.m` and passed through `Main` → `evolveTrajectory` → `forces`. In `forces.m` it scales the Hertz contact force by a prefactor β that depends on the pair type:

| Pair | β |
|---|---|
| cell–cell | 1 |
| gel–gel | `EgEc` |
| cell–gel | `2·EgEc/(1 + EgEc)` (harmonic mean, the same as the paper's [½(1 + Ec/Eg)]⁻¹) |

`EgEc = 1` gives the same stiffness for every particle. To scan stiffness, put `EgEc` into the `ndgrid` in place of one of the other parameters.

## Parameter studies in the paper


| Symbol | Meaning | In the code |
|---|---|---|
| Γ̂ | motility strength (OU noise amplitude) | `gam` |
| ε̂ | cell–cell adhesion strength | `ecap` |
| φc | cell packing fraction (φc + φg = 1) | `pfc` |
| k̂a | inverse persistence time of motility | `Ka` |
| Eg/Ec | gel-to-cell stiffness ratio | `EgEc` |

Settings shared by every study: `dt = 0.01`, `T = 10`, 10 seeds per point, and error bars are the standard deviation over those seeds. The box size is **L = 50 in 2D** and **L = 15 in 3D**.

| Study (paper figure) | Dim | Varied | Fixed |
|---|---|---|---|
| Γ̂–ε̂ phase diagram (Fig. 2b, d, f) | 2D | Γ̂, ε̂ | φc = 0.3, k̂a = 1, Eg/Ec = 1 |
| Γ̂–φc phase diagram (Fig. 2c, e, g) | 2D | Γ̂, φc | ε̂ = 0.3, k̂a = 1, Eg/Ec = 1 |
| Same phase diagrams in 3D (Supp. Fig. S1, S3) | 3D | Γ̂, ε̂ / Γ̂, φc | as for the 2D versions |
| Bond formation and breaking, Γ\* and Γ_opt, cluster density ρ (Fig. 3) | 2D | Γ̂, ε̂ | φc = 0.3, k̂a = 1, Eg/Ec = 1 |
| Occupied area A/A₀ (Fig. 4g) and volume V/V₀ (Fig. 4h) | 2D, 3D | Γ̂, ε̂ | φc = 0.3, k̂a = 1, Eg/Ec = 1 |
| Persistence (Fig. 5) | 2D | k̂a, at Γ̂ = 0.2, 0.6, 1 | ε̂ = 0.5, φc = 0.3, Eg/Ec = 1 |
| Medium stiffness (Fig. 6, Supp. Fig. S7) | 2D | Eg/Ec (e.g. 0.1 to 10), Γ̂ | k̂a = 1, φc = 0.3, ε̂ = 0 (Fig. 6) or ε̂ > 0 (S7) |
| Cell dynamics, MSD vs ε̂ (Fig. 7a–d) | 2D | ε̂ | Γ̂ = 1, k̂a = 1, Eg/Ec = 1, **T = 100** |
| Cell dynamics, MSD vs stiffness (Fig. 7e–f) | 2D | Eg/Ec | Γ̂ = 1, k̂a = 1, ε̂ = 0, **T = 100** |
| No-adhesion control (Supp. Fig. S9) | 2D | Γ̂ | ε̂ = 0 |
| Gel-only oscillatory rheology (Supp. Fig. S5) | 2D | strain amplitude γ̂₀, frequency ω̂ | gels only, L = 50, equilibrated to T = 10 |

### How each study maps onto this code

- **Γ̂, ε̂, φc, k̂a, Eg/Ec, dim:** these are inputs to `Main`. Change the grids in `run_simulations.m`. For example, for the persistence study, scan `Ka` in place of `ecap`, and pass it as the first argument to `Main`. For the stiffness study, scan `EgEc`.
- **3D (L = 15):** set `dim = 3` and `L = 15`. `pack.m` switches to the volume-fraction formula automatically.
- **MSD runs (T = 100):** `T` is hard-coded in `Main.m`, so change it there.


## Model (as implemented in `src/`)

| Quantity | Value | Set in |
|---|---|---|
| Cell radius `rc`, gel radius `rg` | 0.5, 0.5 | `Main.m` |
| Total time `T`, time step `dt` | 10, 0.01 (1001 steps) | `Main.m` |
| Adhesion range `delta` | 0.2 | `Main.m` |
| Number of cells / gels | 2D: `round(φ·L²/(π r²))`; 3D: `round(φ·L³/((4/3)π r³))` | `pack.m` |
| Stiffness ratio Eg/Ec | `EgEc` (1 = equal stiffness) | `run_simulations.m` |

- **Box:** square (2D) or cube (3D), periodic boundaries, every coordinate in [−L/2, L/2].
- **Initial condition:** cells placed at random without overlap (distance ≥ 2rc), then gels placed at random so they don't overlap cells (`generate_IC.m`, `generate_cells.m`).
- **Motion:** overdamped Euler step, `r ← r + (F_passive + F_active)·dt`.
- **Active force (cells only):** Ornstein–Uhlenbeck process, `F ← F − Ka·F·dt + Γ·√dt·η` with η ~ N(0,1). The initial value is `Γ·N(0,1)`. Gels have no active force (`evolve_active_force.m`).
- **Contact (all pairs):** Hertzian repulsion `β · (r1+r2−r)^1.5 · √(r1 r2/(r1+r2))` when overlapping, with β set by `EgEc` and the pair type (`calculate_hertzforce.m`, `forces.m`).
- **Adhesion (cell–cell only):** piecewise-linear attraction that is zero at contact (`r = 2rc`), falls to −ε at `r = 2rc+δ`, and returns to zero at `r = 2rc+2δ` (`calculate_adhesion.m`).

## Files in `src/`

| File | Role |
|---|---|
| `Main.m` | Entry point for one run: makes the output folder, seeds the RNG, sets up, evolves |
| `pack.m` | Number of cells and gels from the packing fractions (2D or 3D) |
| `generate_IC.m` | Initial positions and types (1 = cell, 0 = gel) |
| `generate_cells.m` | Random non-overlapping cell placement |
| `evolveTrajectory.m` | Time loop; writes a frame every step |
| `forces.m` | Pairwise passive forces (contact scaled by `EgEc` + adhesion) |
| `calculate_hertzforce.m` | Hertzian contact force |
| `calculate_adhesion.m` | Cell–cell adhesion force |
| `periodic_displacement.m` | Minimum-image displacement |
| `evolve_active_force.m` | OU update of the active force |
| `check_cond.m` | Wraps positions back into the box |
| `make_file.m` | Writes one `.xyz` frame |

## Output

Each run writes to its own folder:

```
<fp>/ka=1_gamma=0.30_ecap=0.70_Pfc=0.3_EgEc=1.00_seed=001/
    output_0.xyz
    output_1.xyz
    ...
    output_1000.xyz      ← final configuration
```

Each `.xyz` file has this format:

```
<N>
Generated by MATLAB
 <type>  <x>  <y>          (2D)
 <type>  <x>  <y>  <z>    (3D)
 ...
```

where `type` is 1 for a cell and 0 for a gel. Read a frame with:

```matlab
d = readmatrix(file, 'FileType', 'text', 'NumHeaderLines', 2);
```
