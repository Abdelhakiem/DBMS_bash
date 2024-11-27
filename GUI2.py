import streamlit as st

# Example: Hide button based on a condition
hide_button = st.checkbox("Hide button")

if not hide_button:
    if st.button("Click me"):
        st.write("Button clicked!")
else:
    st.write("The button is hidden!")
