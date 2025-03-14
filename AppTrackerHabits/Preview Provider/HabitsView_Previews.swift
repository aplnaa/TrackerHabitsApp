import SwiftUI

struct HabitsView_Previews: PreviewProvider {
    static var previews: some View {
        HabitsView(viewModel: ViewModelFactory.shared.makeHabitsViewModel())
    }
}
