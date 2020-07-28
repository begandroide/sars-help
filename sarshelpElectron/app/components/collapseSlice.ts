import { createSlice } from '@reduxjs/toolkit';
// eslint-disable-next-line import/no-cycle
import { RootState } from '../store';

// import { AppThunk, RootState } from '../store';

const collapseSlice = createSlice({
  name: 'collapseNav',
  initialState: { collapsed: false },
  reducers: {
    collapse: (state) => {
      state.collapsed = !state.collapsed;
    },
  },
});

export const { collapse } = collapseSlice.actions;

export default collapseSlice.reducer;

export const collapseNav = (state: RootState) => state.collapseNav.collapsed;
