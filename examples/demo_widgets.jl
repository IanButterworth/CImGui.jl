using CImGui
using CImGui.CSyntax
using CImGui.CSyntax.CStatic
using CImGui: ImVec2, ImVec4, IM_COL32

"""
    ShowDemoWindowWidgets()
"""
function ShowDemoWindowWidgets()
    !CImGui.CollapsingHeader("Widgets") && return

    if CImGui.TreeNode("Basic")
        @cstatic clicked=Cint(0) begin
            CImGui.Button("Button") && (clicked += 1;)
            if clicked & 1 != 0
                CImGui.SameLine()
                CImGui.Text("Thanks for clicking me!")
            end
        end

        @cstatic check=true @c CImGui.Checkbox("checkbox", &check)

        @cstatic e=Cint(0) begin
            @c CImGui.RadioButton("radio a", &e, 0); CImGui.SameLine()
            @c CImGui.RadioButton("radio b", &e, 1); CImGui.SameLine()
            @c CImGui.RadioButton("radio c", &e, 2);
        end

        # color buttons, demonstrate using PushID() to add unique identifier in the ID stack, and changing style.
        for i = 0:7-1
            i > 0 && CImGui.SameLine()
            CImGui.PushID(i)
            # CImGui.PushStyleColor(CImGui.ImGuiCol_Button, (ImVec4)ImColor::HSV(i/7.0, 0.6, 0.6))
            # CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonHovered, (ImVec4)ImColor::HSV(i/7.0, 0.7, 0.7))
            # CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonActive, (ImVec4)ImColor::HSV(i/7.0, 0.8, 0.8))
            CImGui.Button("Click")
            # CImGui.PopStyleColor(3)
            CImGui.PopID()
        end

        # use AlignTextToFramePadding() to align text baseline to the baseline of framed elements (otherwise a Text+SameLine+Button sequence will have the text a little too high by default)
        CImGui.AlignTextToFramePadding()
        CImGui.Text("Hold to repeat:")
        CImGui.SameLine()

        # arrow buttons with Repeater
        @cstatic counter=Cint(0) begin
            # spacing = CImGui.GetStyle().ItemInnerSpacing.x
            CImGui.PushButtonRepeat(true)
            CImGui.ArrowButton("##left", CImGui.ImGuiDir_Left) && (counter-=1;)
            # CImGui.SameLine(0.0, spacing)
            CImGui.ArrowButton("##right", CImGui.ImGuiDir_Right) && (counter+=1;)
            CImGui.PopButtonRepeat()
            CImGui.SameLine()
            CImGui.Text("$counter")
        end

        CImGui.Text("Hover over me")
        CImGui.IsItemHovered() && CImGui.SetTooltip("I am a tooltip")

        CImGui.SameLine()
        CImGui.Text("- or me")
        if CImGui.IsItemHovered()
            CImGui.BeginTooltip()
            CImGui.Text("I am a fancy tooltip")
            @cstatic arr=Cfloat[0.6, 0.1, 1.0, 0.5, 0.92, 0.1, 0.2] CImGui.PlotLines("Curve", arr, length(arr))
            CImGui.EndTooltip()
        end

        CImGui.Separator()

        CImGui.LabelText("label", "Value")

        @cstatic item_current=Cint(0)
                 items = ["AAAA", "BBBB", "CCCC", "DDDD", "EEEE", "FFFF", "GGGG", "HHHH", "IIII", "JJJJ", "KKKK", "LLLLLLL", "MMMM", "OOOOOOO"]
                begin
            # using the _simplified_ one-liner Combo() api here
            # see "Combo" section for examples of how to use the more complete BeginCombo()/EndCombo() api.
            @c CImGui.Combo("combo", &item_current, items, length(items))
            CImGui.SameLine()
            ShowHelpMarker("Refer to the \"Combo\" section below for an explanation of the full BeginCombo/EndCombo API, and demonstration of various flags.\n")
        end

        @cstatic str0="Hello, world!"*"\0"^115 i0=Cint(123) begin
            CImGui.InputText("input text", str0, length(str0))
            CImGui.SameLine()
            ShowHelpMarker("USER:\nHold SHIFT or use mouse to select text.\n"*"CTRL+Left/Right to word jump.\n"*"CTRL+A or double-click to select all.\n"*"CTRL+X,CTRL+C,CTRL+V clipboard.\n"*"CTRL+Z,CTRL+Y undo/redo.\n"*"ESCAPE to revert.\n\nPROGRAMMER:\nYou can use the ImGuiInputTextFlags_CallbackResize facility if you need to wire InputText() to a dynamic string type. See misc/cpp/imgui_stdlib.h for an example (this is not demonstrated in imgui_demo.cpp).")

            @c CImGui.InputInt("input int", &i0)
            CImGui.SameLine(); ShowHelpMarker("You can apply arithmetic operators +,*,/ on numerical values.\n  e.g. [ 100 ], input \'*2\', result becomes [ 200 ]\nUse +- to subtract.\n")
        end

        @cstatic f0=Cfloat(0.001) d0=Cdouble(999999.00000001) f1=Cfloat(1.e10) begin
            @c CImGui.InputFloat("input float", &f0, 0.01, 1.0, "%.3f")
            @c CImGui.InputDouble("input double", &d0, 0.01, 1.0, "%.8f")
            @c CImGui.InputFloat("input scientific", &f1, 0.0, 0.0, "%e")
            CImGui.SameLine()
            ShowHelpMarker("You can input value using the scientific notation,\n  e.g. \"1e+8\" becomes \"100000000\".\n")
        end
        @cstatic vec4a=Cfloat[0.10, 0.20, 0.30, 0.44] CImGui.InputFloat3("input float3", vec4a)

        @cstatic i1=Cint(50) i2=Cint(42) begin
            @c CImGui.DragInt("drag int", &i1, 1)
            CImGui.SameLine()
            ShowHelpMarker("Click and drag to edit value.\nHold SHIFT/ALT for faster/slower edit.\nDouble-click or CTRL+click to input value.")

            @c CImGui.DragInt("drag int 0..100", &i2, 1, 0, 100, "%d%%")
        end

        @cstatic f1=Cfloat(1.00) f2=Cfloat(0.0067) begin
            @c CImGui.DragFloat("drag float", &f1, 0.005)
            @c CImGui.DragFloat("drag small float", &f2, 0.0001, 0.0, 0.0, "%.06f ns")
        end

        @cstatic i1=Cint(0) f1=Cfloat(0.123) f2=Cfloat(0.0) angle=Cfloat(0.0) begin
            @c CImGui.SliderInt("slider int", &i1, -1, 3)
            CImGui.SameLine()
            ShowHelpMarker("CTRL+click to input value.")

            @c CImGui.SliderFloat("slider float", &f1, 0.0, 1.0, "ratio = %.3f")
            @c CImGui.SliderFloat("slider float (curve)", &f2, -10.0, 10.0, "%.4f", 2.0)

            @c CImGui.SliderAngle("slider angle", &angle)
        end

        @cstatic col1=Cfloat[1.0,0.0,0.2] col2=Cfloat[0.4,0.7,0.0,0.5] begin
            CImGui.ColorEdit3("color 1", col1)
            CImGui.SameLine()
            ShowHelpMarker("Click on the colored square to open a color picker.\nClick and hold to use drag and drop.\nRight-click on the colored square to show options.\nCTRL+click on individual component to input value.\n")
            CImGui.ColorEdit4("color 2", col2)
        end

        @cstatic listbox_item_current=Cint(1) listbox_items=["Apple", "Banana", "Cherry", "Kiwi", "Mango", "Orange", "Pineapple", "Strawberry", "Watermelon"] begin
            # list box
            @c CImGui.ListBox("listbox\n(single select)", &listbox_item_current, listbox_items, length(listbox_items), 4)
        end
        # CImGui.PushItemWidth(-1)
        # CImGui.ListBox("##listbox2", &listbox_item_current2, listbox_items, length(listbox_items), 4)
        # CImGui.PopItemWidth()

        CImGui.TreePop()
    end

    # TODO:
    # Testing ImGuiOnceUponAFrame helper.
    # static ImGuiOnceUponAFrame once;
    # for (int i = 0; i < 5; i++)
    #     if (once)
    #         CImGui.Text("This will be displayed only once.");
    if CImGui.TreeNode("Trees")
        if CImGui.TreeNode("Basic trees")
            for i = 0:4
                if CImGui.TreeNode(Ptr{Cvoid}(i), "Child $i")
                    CImGui.Text("blah blah")
                    CImGui.SameLine()
                    CImGui.SmallButton("button") && @info "Trigger `Basic trees`'s button | find me here: $(@__FILE__) at line $(@__LINE__)"
                    CImGui.TreePop()
                end
            end
            CImGui.TreePop()
        end

        if CImGui.TreeNode("Advanced, with Selectable nodes")
            ShowHelpMarker("This is a more standard looking tree with selectable nodes.\nClick to select, CTRL+Click to toggle, click on arrows or double-click to open.")
            align_label_with_current_x_position= @cstatic align_label_with_current_x_position=false begin
                @c CImGui.Checkbox("Align label with current X position)", &align_label_with_current_x_position)
                CImGui.Text("Hello!")
                align_label_with_current_x_position && CImGui.Unindent(CImGui.GetTreeNodeToLabelSpacing())
            end

@cstatic selection_mask=Cint(1 << 2) begin  # dumb representation of what may be user-side selection state. You may carry selection state inside or outside your objects in whatever format you see fit.
            node_clicked = -1               # temporary storage of what node we have clicked to process selection at the end of the loop. May be a pointer to your own node type, etc.
            CImGui.PushStyleVar(CImGui.ImGuiStyleVar_IndentSpacing, CImGui.GetFontSize()*3) # increase spacing to differentiate leaves from expanded contents.
            for i = 0:5
                # disable the default open on single-click behavior and pass in Selected flag according to our selection state.
                node_flags = CImGui.ImGuiTreeNodeFlags_OpenOnArrow | CImGui.ImGuiTreeNodeFlags_OpenOnDoubleClick | ((selection_mask & (1 << i)) != 0 ? CImGui.ImGuiTreeNodeFlags_Selected : 0)
                if i < 3
                    # Node
                    node_open = CImGui.TreeNodeEx(Ptr{Cvoid}(i), node_flags, "Selectable Node $i")
                    CImGui.IsItemClicked() && (node_clicked = i;)
                    node_open && (CImGui.Text("Blah blah\nBlah Blah"); CImGui.TreePop();)
                else
                    # Leaf: The only reason we have a TreeNode at all is to allow selection of the leaf. Otherwise we can use BulletText() or TreeAdvanceToLabelPos()+Text().
                    node_flags |= CImGui.ImGuiTreeNodeFlags_Leaf | CImGui.ImGuiTreeNodeFlags_NoTreePushOnOpen # CImGui.ImGuiTreeNodeFlags_Bullet
                    CImGui.TreeNodeEx(Ptr{Cvoid}(i), node_flags, "Selectable Leaf $i")
                    CImGui.IsItemClicked() && (node_clicked = i;)
                end
            end
            if node_clicked != -1
                # update selection state. Process outside of tree loop to avoid visual inconsistencies during the clicking-frame.
                if CImGui.GetIO().KeyCtrl
                    selection_mask ⊻= 1 << node_clicked           # CTRL+click to toggle
                else #if (!(selection_mask & (1 << node_clicked))) # Depending on selection behavior you want, this commented bit preserve selection when clicking on item that is part of the selection
                    selection_mask = 1 << node_clicked            # Click to single-select
                end
            end
            CImGui.PopStyleVar()
end # @cstatic
            align_label_with_current_x_position && CImGui.Indent(CImGui.GetTreeNodeToLabelSpacing())
            CImGui.TreePop()
        end
        CImGui.TreePop()
    end

    if CImGui.TreeNode("Collapsing Headers")
        @cstatic closable_group=true begin
            @c CImGui.Checkbox("Enable extra group", &closable_group)
            if CImGui.CollapsingHeader("Header")
                CImGui.Text("IsItemHovered: $(CImGui.IsItemHovered())")
                foreach(i->CImGui.Text("Some content $i"), 0:4)
            end
            if @c CImGui.CollapsingHeader("Header with a close button", &closable_group)
                CImGui.Text("IsItemHovered: $(CImGui.IsItemHovered())")
                foreach(i->CImGui.Text("More content $i"), 0:4)
            end
        end
        CImGui.TreePop()
    end

    if CImGui.TreeNode("Bullets")
        CImGui.BulletText("Bullet point 1")
        CImGui.BulletText("Bullet point 2\nOn multiple lines")
        CImGui.Bullet()
        CImGui.Text("Bullet point 3 (two calls)")
        CImGui.Bullet()
        CImGui.SmallButton("Button") && @info "Trigger `Bullets`'s Button | find me here: $(@__FILE__) at line $(@__LINE__)"
        CImGui.TreePop()
    end

    if CImGui.TreeNode("Text")
        if CImGui.TreeNode("Colored Text")
            # using shortcut. You can use PushStyleColor()/PopStyleColor() for more flexibility.
            CImGui.TextColored(ImVec4(1.0,0.0,1.0,1.0), "Pink")
            CImGui.TextColored(ImVec4(1.0,1.0,0.0,1.0), "Yellow")
            CImGui.TextDisabled("Disabled")
            CImGui.SameLine()
            ShowHelpMarker("The TextDisabled color is stored in ImGuiStyle.")
            CImGui.TreePop()
        end

        if CImGui.TreeNode("Word Wrapping")
            # using shortcut. You can use PushTextWrapPos()/PopTextWrapPos() for more flexibility.
            CImGui.TextWrapped("This text should automatically wrap on the edge of the window. The current implementation for text wrapping follows simple rules suitable for English and possibly other languages.")
            CImGui.Spacing()

@cstatic wrap_width = Cfloat(200.0) begin
            @c CImGui.SliderFloat("Wrap width", &wrap_width, -20, 600, "%.0f")

            CImGui.Text("Test paragraph 1:")
            pos = CImGui.GetCursorScreenPos()
            draw_list = CImGui.GetWindowDrawList()
            CImGui.AddRectFilled(draw_list, ImVec2(pos.x + wrap_width, pos.y), ImVec2(pos.x + wrap_width + 10, pos.y + CImGui.GetTextLineHeight()), IM_COL32(255,0,255,255))
            CImGui.PushTextWrapPos(CImGui.GetCursorPos().x + wrap_width)
            CImGui.Text("The lazy dog is a good dog. This paragraph is made to fit within $wrap_width pixels. Testing a 1 character word. The quick brown fox jumps over the lazy dog.")
            CImGui.AddRect(draw_list, CImGui.GetItemRectMin(), CImGui.GetItemRectMax(), IM_COL32(255,255,0,255))
            CImGui.PopTextWrapPos()

            CImGui.Text("Test paragraph 2:")
            pos = CImGui.GetCursorScreenPos()
            CImGui.AddRectFilled(draw_list, ImVec2(pos.x + wrap_width, pos.y), ImVec2(pos.x + wrap_width + 10, pos.y + CImGui.GetTextLineHeight()), IM_COL32(255,0,255,255))
            CImGui.PushTextWrapPos(CImGui.GetCursorPos().x + wrap_width)
            CImGui.Text("aaaaaaaa bbbbbbbb, c cccccccc,dddddddd. d eeeeeeee   ffffffff. gggggggg!hhhhhhhh")
            CImGui.AddRect(draw_list, CImGui.GetItemRectMin(), CImGui.GetItemRectMax(), IM_COL32(255,255,0,255))
            CImGui.PopTextWrapPos()
end
            CImGui.TreePop()
        end

        # if CImGui.TreeNode("UTF-8 Text")
        #     # UTF-8 test with Japanese characters
        #     # (Needs a suitable font, try Noto, or Arial Unicode, or M+ fonts. Read misc/fonts/README.txt for details.)
        #     # - From C++11 you can use the u8"my text" syntax to encode literal strings as UTF-8
        #     # - For earlier compiler, you may be able to encode your sources as UTF-8 (e.g. Visual Studio save your file as 'UTF-8 without signature')
        #     # - FOR THIS DEMO FILE ONLY, BECAUSE WE WANT TO SUPPORT OLD COMPILERS, WE ARE *NOT* INCLUDING RAW UTF-8 CHARACTERS IN THIS SOURCE FILE.
        #     #   Instead we are encoding a few strings with hexadecimal constants. Don't do this in your application!
        #     #   Please use u8"text in any language" in your application!
        #     # Note that characters values are preserved even by InputText() if the font cannot be displayed, so you can safely copy & paste garbled characters into another application.
        #     CImGui.TextWrapped("CJK text will only appears if the font was loaded with the appropriate CJK character ranges. Call io.Font->AddFontFromFileTTF() manually to load extra character ranges. Read misc/fonts/README.txt for details.")
        #     CImGui.Text("Hiragana: \xe3\x81\x8b\xe3\x81\x8d\xe3\x81\x8f\xe3\x81\x91\xe3\x81\x93 (kakikukeko)") # Normally we would use u8"blah blah" with the proper characters directly in the string.
        #     CImGui.Text("Kanjis: \xe6\x97\xa5\xe6\x9c\xac\xe8\xaa\x9e (nihongo)")
        #     static char buf[32] = "\xe6\x97\xa5\xe6\x9c\xac\xe8\xaa\x9e"
        #     CImGui.InputText("UTF-8 input", buf, IM_ARRAYSIZE(buf))
        #     CImGui.TreePop()
        # end
        CImGui.TreePop()
    end

    # if (CImGui.TreeNode("Images"))
    # {
    #     ImGuiIO& io = CImGui.GetIO();
    #     CImGui.TextWrapped("Below we are displaying the font texture (which is the only texture we have access to in this demo). Use the 'ImTextureID' type as storage to pass pointers or identifier to your own texture data. Hover the texture for a zoomed view!");
    #
    #     // Here we are grabbing the font texture because that's the only one we have access to inside the demo code.
    #     // Remember that ImTextureID is just storage for whatever you want it to be, it is essentially a value that will be passed to the render function inside the ImDrawCmd structure.
    #     // If you use one of the default imgui_impl_XXXX.cpp renderer, they all have comments at the top of their file to specify what they expect to be stored in ImTextureID.
    #     // (for example, the imgui_impl_dx11.cpp renderer expect a 'ID3D11ShaderResourceView*' pointer. The imgui_impl_glfw_gl3.cpp renderer expect a GLuint OpenGL texture identifier etc.)
    #     // If you decided that ImTextureID = MyEngineTexture*, then you can pass your MyEngineTexture* pointers to CImGui.Image(), and gather width/height through your own functions, etc.
    #     // Using ShowMetricsWindow() as a "debugger" to inspect the draw data that are being passed to your render will help you debug issues if you are confused about this.
    #     // Consider using the lower-level ImDrawList::AddImage() API, via CImGui.GetWindowDrawList()->AddImage().
    #     ImTextureID my_tex_id = io.Fonts->TexID;
    #     float my_tex_w = (float)io.Fonts->TexWidth;
    #     float my_tex_h = (float)io.Fonts->TexHeight;
    #
    #     CImGui.Text("%.0fx%.0f", my_tex_w, my_tex_h);
    #     ImVec2 pos = CImGui.GetCursorScreenPos();
    #     CImGui.Image(my_tex_id, ImVec2(my_tex_w, my_tex_h), ImVec2(0,0), ImVec2(1,1), ImColor(255,255,255,255), ImColor(255,255,255,128));
    #     if (CImGui.IsItemHovered())
    #     {
    #         CImGui.BeginTooltip();
    #         float region_sz = 32.0f;
    #         float region_x = io.MousePos.x - pos.x - region_sz * 0.5f; if (region_x < 0.0f) region_x = 0.0f; else if (region_x > my_tex_w - region_sz) region_x = my_tex_w - region_sz;
    #         float region_y = io.MousePos.y - pos.y - region_sz * 0.5f; if (region_y < 0.0f) region_y = 0.0f; else if (region_y > my_tex_h - region_sz) region_y = my_tex_h - region_sz;
    #         float zoom = 4.0f;
    #         CImGui.Text("Min: (%.2f, %.2f)", region_x, region_y);
    #         CImGui.Text("Max: (%.2f, %.2f)", region_x + region_sz, region_y + region_sz);
    #         ImVec2 uv0 = ImVec2((region_x) / my_tex_w, (region_y) / my_tex_h);
    #         ImVec2 uv1 = ImVec2((region_x + region_sz) / my_tex_w, (region_y + region_sz) / my_tex_h);
    #         CImGui.Image(my_tex_id, ImVec2(region_sz * zoom, region_sz * zoom), uv0, uv1, ImColor(255,255,255,255), ImColor(255,255,255,128));
    #         CImGui.EndTooltip();
    #     }
    #     CImGui.TextWrapped("And now some textured buttons..");
    #     static int pressed_count = 0;
    #     for (int i = 0; i < 8; i++)
    #     {
    #         CImGui.PushID(i);
    #         int frame_padding = -1 + i;     // -1 = uses default padding
    #         if (CImGui.ImageButton(my_tex_id, ImVec2(32,32), ImVec2(0,0), ImVec2(32.0f/my_tex_w,32/my_tex_h), frame_padding, ImColor(0,0,0,255)))
    #             pressed_count += 1;
    #         CImGui.PopID();
    #         CImGui.SameLine();
    #     }
    #     CImGui.NewLine();
    #     CImGui.Text("Pressed %d times.", pressed_count);
    #     CImGui.TreePop();
    # }
    #
    if CImGui.TreeNode("Combo")
        # expose flags as checkbox for the demo
        flags = @cstatic flags=Cint(0) begin
            @c CImGui.CheckboxFlags("ImGuiComboFlags_PopupAlignLeft", &flags, CImGui.ImGuiComboFlags_PopupAlignLeft)
            if @c(CImGui.CheckboxFlags("ImGuiComboFlags_NoArrowButton", &flags, CImGui.ImGuiComboFlags_NoArrowButton)) != 0
                flags &= ~CImGui.ImGuiComboFlags_NoPreview # clear the other flag, as we cannot combine both
            end
            if @c(CImGui.CheckboxFlags("ImGuiComboFlags_NoPreview", &flags, CImGui.ImGuiComboFlags_NoPreview)) != 0
                flags &= ~CImGui.ImGuiComboFlags_NoArrowButton # clear the other flag, as we cannot combine both
            end
        end

        # general BeginCombo() API, you have full control over your selection data and display type.
        # (your selection data could be an index, a pointer to the object, an id for the object, a flag stored in the object itself, etc.)
        items = ["AAAA", "BBBB", "CCCC", "DDDD", "EEEE", "FFFF", "GGGG", "HHHH", "IIII", "JJJJ", "KKKK", "LLLLLLL", "MMMM", "OOOOOOO"]
        @cstatic item_current="AAAA" begin
            # here our selection is a single pointer stored outside the object.
            if CImGui.BeginCombo("combo 1", item_current, flags) # the second parameter is the label previewed before opening the combo.
                for n = 0:length(items)-1
                    is_selected = item_current == items[n+1]
                    CImGui.Selectable(items[n+1], is_selected) && (item_current = items[n+1];)
                    is_selected && CImGui.SetItemDefaultFocus() # set the initial focus when opening the combo (scrolling + for keyboard navigation support in the upcoming navigation branch)
                end
                CImGui.EndCombo()
            end
        end

        # simplified one-liner Combo() API, using values packed in a single constant string
        @cstatic item_current_2=Cint(0) begin
            @c CImGui.Combo("combo 2 (one-liner)", &item_current_2, "aaaa\0bbbb\0cccc\0dddd\0eeee\0\0")
        end

        # simplified one-liner Combo() using an array of const char*
        @cstatic item_current_3=Cint(-1) begin
            # if the selection isn't within 0..count, Combo won't display a preview
            @c CImGui.Combo("combo 3 (array)", &item_current_3, items, length(items))
        end

        # simplified one-liner Combo() using an accessor function
        # struct FuncHolder { static bool ItemGetter(void* data, int idx, const char** out_str) { *out_str = ((const char**)data)[idx]; return true; } };
        # static int item_current_4 = 0;
        # CImGui.Combo("combo 4 (function)", &item_current_4, &FuncHolder::ItemGetter, items, IM_ARRAYSIZE(items));

        CImGui.TreePop()
    end

    if CImGui.TreeNode("Selectables")
        # Selectable() has 2 overloads:
        # - The one taking "bool selected" as a read-only selection information. When Selectable() has been clicked is returns true and you can alter selection state accordingly.
        # - The one taking "bool* p_selected" as a read-write selection information (convenient in some cases)
        #  The earlier is more flexible, as in real application your selection may be stored in a different manner (in flags within objects, as an external list, etc).
        if CImGui.TreeNode("Basic")
            @cstatic selection = [false, true, false, false, false] begin
                CImGui.Selectable("1. I am selectable", pointer(selection))
                CImGui.Selectable("2. I am selectable", pointer(selection)+sizeof(Bool))
                CImGui.Text("3. I am not selectable")
                CImGui.Selectable("4. I am selectable", pointer(selection)+3*sizeof(Bool))
                if CImGui.Selectable("5. I am double clickable", pointer(selection)+4*sizeof(Bool), CImGui.ImGuiSelectableFlags_AllowDoubleClick)
                    CImGui.IsMouseDoubleClicked(0) && (selection[5] = !selection[5];)
                end
            end
            CImGui.TreePop()
        end
        if CImGui.TreeNode("Selection State: Single Selection")
            @cstatic selected = Cint(-1) begin
                for n = 0:4
                    buf = @sprintf "Object %d" n
                    CImGui.Selectable(buf, selected == n) && (selected = n;)
                end
            end
            CImGui.TreePop()
        end
        if CImGui.TreeNode("Selection State: Multiple Selection")
            ShowHelpMarker("Hold CTRL and click to select multiple items.")
            @cstatic selection=[false, false, false, false, false] begin
                for n = 0:4
                    buf = @sprintf "Object %d" n
                    if CImGui.Selectable(buf, selection[n+1])
                        # clear selection when CTRL is not held
                        !CImGui.GetIO().KeyCtrl && fill!(selection, false)
                        selection[n+1] ⊻= 1
                    end
                end
            end
            CImGui.TreePop()
        end
        if CImGui.TreeNode("Rendering more text into the same line")
            # using the Selectable() override that takes "bool* p_selected" parameter and toggle your booleans automatically.
            @cstatic selected=[false, false, false] begin
                CImGui.Selectable("main.c", pointer(selected))
                CImGui.SameLine(300)
                CImGui.Text(" 2,345 bytes")
                CImGui.Selectable("Hello.cpp", pointer(selected)+sizeof(Bool))
                CImGui.SameLine(300)
                CImGui.Text("12,345 bytes")
                CImGui.Selectable("Hello.h", pointer(selected)+2sizeof(Bool))
                CImGui.SameLine(300)
                CImGui.Text(" 2,345 bytes")
            end
            CImGui.TreePop()
        end
        if CImGui.TreeNode("In columns")
            CImGui.Columns(3, C_NULL, false)
            @cstatic selected=[false for i = 1:16] begin
                for i = 0:16-1
                    label = @sprintf("Item %d", i)
                    CImGui.Selectable(label, pointer(selected)+i*sizeof(Bool)) && @info "Trigger | find me here: $(@__FILE__) at line $(@__LINE__)"
                    CImGui.NextColumn()
                end
                CImGui.Columns(1)
            end
            CImGui.TreePop()
        end
        if CImGui.TreeNode("Grid")
            @cstatic selected=[true, false, false, false, false, true, false, false, false, false, true, false, false, false, false, true] begin
                for i = 0:4*4-1
                    CImGui.PushID(i)
                    if CImGui.Selectable("Sailor", pointer(selected)+i*sizeof(Bool), 0, ImVec2(50,50))
                        # note: We _unnecessarily_ test for both x/y and i here only to silence some static analyzer. The second part of each test is unnecessary.
                        x = i % 4
                        y = i / 4
                        x > 0 && (selected[i] ⊻= 1;)
                        (x < 3 && i < 15) && (selected[i + 2] ⊻= 1;)
                        (y > 0 && i > 3) && (selected[i - 3] ⊻= 1;)
                        (y < 3 && i < 12) && (selected[i + 5] ⊻= 1;)
                    end
                    (i % 4) < 3 && CImGui.SameLine()
                    CImGui.PopID()
                end
            end
            CImGui.TreePop()
        end
        if CImGui.TreeNode("Alignment")
            ShowHelpMarker("Alignment applies when a selectable is larger than its text content.\nBy default, Selectables uses style.SelectableTextAlign but it can be overriden on a per-item basis using PushStyleVar().");
            @cstatic selected=[true, false, true, false, true, false, true, false, true] begin
                for y = 0:3-1
                    for x = 0:3-1
                        alignment = ImVec2(x / 2.0, y / 2.0)
                        name = @sprintf("(%.1f,%.1f)", alignment.x, alignment.y)
                        x > 0 && CImGui.SameLine()
                        CImGui.PushStyleVar(CImGui.ImGuiStyleVar_SelectableTextAlign, alignment)
                        CImGui.Selectable(name, pointer(selected)+(3*y+x)*sizeof(Bool), CImGui.ImGuiSelectableFlags_None, ImVec2(80,80))
                        CImGui.PopStyleVar()
                    end
                end
            end
            CImGui.TreePop()
        end
        CImGui.TreePop()
    end

    # if (CImGui.TreeNode("Filtered Text Input"))
    # {
    #     static char buf1[64] = ""; CImGui.InputText("default", buf1, 64);
    #     static char buf2[64] = ""; CImGui.InputText("decimal", buf2, 64, ImGuiInputTextFlags_CharsDecimal);
    #     static char buf3[64] = ""; CImGui.InputText("hexadecimal", buf3, 64, ImGuiInputTextFlags_CharsHexadecimal | ImGuiInputTextFlags_CharsUppercase);
    #     static char buf4[64] = ""; CImGui.InputText("uppercase", buf4, 64, ImGuiInputTextFlags_CharsUppercase);
    #     static char buf5[64] = ""; CImGui.InputText("no blank", buf5, 64, ImGuiInputTextFlags_CharsNoBlank);
    #     struct TextFilters { static int FilterImGuiLetters(ImGuiInputTextCallbackData* data) { if (data->EventChar < 256 && strchr("imgui", (char)data->EventChar)) return 0; return 1; } };
    #     static char buf6[64] = ""; CImGui.InputText("\"imgui\" letters", buf6, 64, ImGuiInputTextFlags_CallbackCharFilter, TextFilters::FilterImGuiLetters);
    #
    #     CImGui.Text("Password input");
    #     static char bufpass[64] = "password123";
    #     CImGui.InputText("password", bufpass, 64, ImGuiInputTextFlags_Password | ImGuiInputTextFlags_CharsNoBlank);
    #     CImGui.SameLine(); ShowHelpMarker("Display all characters as '*'.\nDisable clipboard cut and copy.\nDisable logging.\n");
    #     CImGui.InputText("password (clear)", bufpass, 64, ImGuiInputTextFlags_CharsNoBlank);
    #
    #     CImGui.TreePop();
    # }

    if CImGui.TreeNode("Multi-line Text Input")
        # note: we are using a fixed-sized buffer for simplicity here. See ImGuiInputTextFlags_CallbackResize
        # and the code in misc/cpp/imgui_stdlib.h for how to setup InputText() for dynamically resizing strings.
        @cstatic read_only=false (text="/*\n"*
                                       " The Pentium F00F bug, shorthand for F0 0F C7 C8,\n"*
                                       " more formally, the invalid operand with locked CMPXCHG8B\n"*
                                       " instruction bug, is a design flaw in the majority of\n"*
                                       " Intel Pentium, Pentium MMX, and Pentium OverDrive\n"*
                                       " processors (all in the P5 microarchitecture).\n"*
                                       "*/\n\n"*
                                       "label:\n"*
                                       "\tlock cmpxchg8b eax\n"*"\0"^(1024*16-249)) begin
            ShowHelpMarker("You can use the ImGuiInputTextFlags_CallbackResize facility if you need to wire InputTextMultiline() to a dynamic string type. See misc/cpp/imgui_stdlib.h for an example. (This is not demonstrated in imgui_demo.cpp)")
            @c CImGui.Checkbox("Read-only", &read_only)
            flags = CImGui.ImGuiInputTextFlags_AllowTabInput | (read_only ? CImGui.ImGuiInputTextFlags_ReadOnly : 0)
            CImGui.InputTextMultiline("##source", text, length(text), ImVec2(-1.0, CImGui.GetTextLineHeight() * 16), flags)
            CImGui.TreePop()
        end
    end

    # if (CImGui.TreeNode("Plots Widgets"))
    # {
    #     static bool animate = true;
    #     CImGui.Checkbox("Animate", &animate);
    #
    #     static float arr[] = { 0.6f, 0.1f, 1.0f, 0.5f, 0.92f, 0.1f, 0.2f };
    #     CImGui.PlotLines("Frame Times", arr, IM_ARRAYSIZE(arr));
    #
    #     // Create a dummy array of contiguous float values to plot
    #     // Tip: If your float aren't contiguous but part of a structure, you can pass a pointer to your first float and the sizeof() of your structure in the Stride parameter.
    #     static float values[90] = { 0 };
    #     static int values_offset = 0;
    #     static double refresh_time = 0.0;
    #     if (!animate || refresh_time == 0.0)
    #         refresh_time = CImGui.GetTime();
    #     while (refresh_time < CImGui.GetTime()) // Create dummy data at fixed 60 hz rate for the demo
    #     {
    #         static float phase = 0.0f;
    #         values[values_offset] = cosf(phase);
    #         values_offset = (values_offset+1) % IM_ARRAYSIZE(values);
    #         phase += 0.10f*values_offset;
    #         refresh_time += 1.0f/60.0f;
    #     }
    #     CImGui.PlotLines("Lines", values, IM_ARRAYSIZE(values), values_offset, "avg 0.0", -1.0f, 1.0f, ImVec2(0,80));
    #     CImGui.PlotHistogram("Histogram", arr, IM_ARRAYSIZE(arr), 0, NULL, 0.0f, 1.0f, ImVec2(0,80));
    #
    #     // Use functions to generate output
    #     // FIXME: This is rather awkward because current plot API only pass in indices. We probably want an API passing floats and user provide sample rate/count.
    #     struct Funcs
    #     {
    #         static float Sin(void*, int i) { return sinf(i * 0.1f); }
    #         static float Saw(void*, int i) { return (i & 1) ? 1.0f : -1.0f; }
    #     };
    #     static int func_type = 0, display_count = 70;
    #     CImGui.Separator();
    #     CImGui.PushItemWidth(100); CImGui.Combo("func", &func_type, "Sin\0Saw\0"); CImGui.PopItemWidth();
    #     CImGui.SameLine();
    #     CImGui.SliderInt("Sample count", &display_count, 1, 400);
    #     float (*func)(void*, int) = (func_type == 0) ? Funcs::Sin : Funcs::Saw;
    #     CImGui.PlotLines("Lines", func, NULL, display_count, 0, NULL, -1.0f, 1.0f, ImVec2(0,80));
    #     CImGui.PlotHistogram("Histogram", func, NULL, display_count, 0, NULL, -1.0f, 1.0f, ImVec2(0,80));
    #     CImGui.Separator();
    #
    #     // Animate a simple progress bar
    #     static float progress = 0.0f, progress_dir = 1.0f;
    #     if (animate)
    #     {
    #         progress += progress_dir * 0.4f * CImGui.GetIO().DeltaTime;
    #         if (progress >= +1.1f) { progress = +1.1f; progress_dir *= -1.0f; }
    #         if (progress <= -0.1f) { progress = -0.1f; progress_dir *= -1.0f; }
    #     }
    #
    #     // Typically we would use ImVec2(-1.0f,0.0f) to use all available width, or ImVec2(width,0.0f) for a specified width. ImVec2(0.0f,0.0f) uses ItemWidth.
    #     CImGui.ProgressBar(progress, ImVec2(0.0f,0.0f));
    #     CImGui.SameLine(0.0f, CImGui.GetStyle().ItemInnerSpacing.x);
    #     CImGui.Text("Progress Bar");
    #
    #     float progress_saturated = (progress < 0.0f) ? 0.0f : (progress > 1.0f) ? 1.0f : progress;
    #     char buf[32];
    #     sprintf(buf, "%d/%d", (int)(progress_saturated*1753), 1753);
    #     CImGui.ProgressBar(progress, ImVec2(0.f,0.f), buf);
    #     CImGui.TreePop();
    # }
    #
    # if (CImGui.TreeNode("Color/Picker Widgets"))
    # {
    #     static ImVec4 color = ImVec4(114.0f/255.0f, 144.0f/255.0f, 154.0f/255.0f, 200.0f/255.0f);
    #
    #     static bool alpha_preview = true;
    #     static bool alpha_half_preview = false;
    #     static bool drag_and_drop = true;
    #     static bool options_menu = true;
    #     static bool hdr = false;
    #     CImGui.Checkbox("With Alpha Preview", &alpha_preview);
    #     CImGui.Checkbox("With Half Alpha Preview", &alpha_half_preview);
    #     CImGui.Checkbox("With Drag and Drop", &drag_and_drop);
    #     CImGui.Checkbox("With Options Menu", &options_menu); CImGui.SameLine(); ShowHelpMarker("Right-click on the individual color widget to show options.");
    #     CImGui.Checkbox("With HDR", &hdr); CImGui.SameLine(); ShowHelpMarker("Currently all this does is to lift the 0..1 limits on dragging widgets.");
    #     int misc_flags = (hdr ? ImGuiColorEditFlags_HDR : 0) | (drag_and_drop ? 0 : ImGuiColorEditFlags_NoDragDrop) | (alpha_half_preview ? ImGuiColorEditFlags_AlphaPreviewHalf : (alpha_preview ? ImGuiColorEditFlags_AlphaPreview : 0)) | (options_menu ? 0 : ImGuiColorEditFlags_NoOptions);
    #
    #     CImGui.Text("Color widget:");
    #     CImGui.SameLine(); ShowHelpMarker("Click on the colored square to open a color picker.\nCTRL+click on individual component to input value.\n");
    #     CImGui.ColorEdit3("MyColor##1", (float*)&color, misc_flags);
    #
    #     CImGui.Text("Color widget HSV with Alpha:");
    #     CImGui.ColorEdit4("MyColor##2", (float*)&color, ImGuiColorEditFlags_HSV | misc_flags);
    #
    #     CImGui.Text("Color widget with Float Display:");
    #     CImGui.ColorEdit4("MyColor##2f", (float*)&color, ImGuiColorEditFlags_Float | misc_flags);
    #
    #     CImGui.Text("Color button with Picker:");
    #     CImGui.SameLine(); ShowHelpMarker("With the ImGuiColorEditFlags_NoInputs flag you can hide all the slider/text inputs.\nWith the ImGuiColorEditFlags_NoLabel flag you can pass a non-empty label which will only be used for the tooltip and picker popup.");
    #     CImGui.ColorEdit4("MyColor##3", (float*)&color, ImGuiColorEditFlags_NoInputs | ImGuiColorEditFlags_NoLabel | misc_flags);
    #
    #     CImGui.Text("Color button with Custom Picker Popup:");
    #
    #     // Generate a dummy default palette. The palette will persist and can be edited.
    #     static bool saved_palette_init = true;
    #     static ImVec4 saved_palette[32] = { };
    #     if (saved_palette_init)
    #     {
    #         for (int n = 0; n < IM_ARRAYSIZE(saved_palette); n++)
    #         {
    #             CImGui.ColorConvertHSVtoRGB(n / 31.0f, 0.8f, 0.8f, saved_palette[n].x, saved_palette[n].y, saved_palette[n].z);
    #             saved_palette[n].w = 1.0f; // Alpha
    #         }
    #         saved_palette_init = false;
    #     }
    #
    #     static ImVec4 backup_color;
    #     bool open_popup = CImGui.ColorButton("MyColor##3b", color, misc_flags);
    #     CImGui.SameLine();
    #     open_popup |= CImGui.Button("Palette");
    #     if (open_popup)
    #     {
    #         CImGui.OpenPopup("mypicker");
    #         backup_color = color;
    #     }
    #     if (CImGui.BeginPopup("mypicker"))
    #     {
    #         CImGui.Text("MY CUSTOM COLOR PICKER WITH AN AMAZING PALETTE!");
    #         CImGui.Separator();
    #         CImGui.ColorPicker4("##picker", (float*)&color, misc_flags | ImGuiColorEditFlags_NoSidePreview | ImGuiColorEditFlags_NoSmallPreview);
    #         CImGui.SameLine();
    #
    #         CImGui.BeginGroup(); // Lock X position
    #         CImGui.Text("Current");
    #         CImGui.ColorButton("##current", color, ImGuiColorEditFlags_NoPicker | ImGuiColorEditFlags_AlphaPreviewHalf, ImVec2(60,40));
    #         CImGui.Text("Previous");
    #         if (CImGui.ColorButton("##previous", backup_color, ImGuiColorEditFlags_NoPicker | ImGuiColorEditFlags_AlphaPreviewHalf, ImVec2(60,40)))
    #             color = backup_color;
    #         CImGui.Separator();
    #         CImGui.Text("Palette");
    #         for (int n = 0; n < IM_ARRAYSIZE(saved_palette); n++)
    #         {
    #             CImGui.PushID(n);
    #             if ((n % 8) != 0)
    #                 CImGui.SameLine(0.0f, CImGui.GetStyle().ItemSpacing.y);
    #             if (CImGui.ColorButton("##palette", saved_palette[n], ImGuiColorEditFlags_NoAlpha | ImGuiColorEditFlags_NoPicker | ImGuiColorEditFlags_NoTooltip, ImVec2(20,20)))
    #                 color = ImVec4(saved_palette[n].x, saved_palette[n].y, saved_palette[n].z, color.w); // Preserve alpha!
    #
    #             // Allow user to drop colors into each palette entry
    #             // (Note that ColorButton is already a drag source by default, unless using ImGuiColorEditFlags_NoDragDrop)
    #             if (CImGui.BeginDragDropTarget())
    #             {
    #                 if (const ImGuiPayload* payload = CImGui.AcceptDragDropPayload(IMGUI_PAYLOAD_TYPE_COLOR_3F))
    #                     memcpy((float*)&saved_palette[n], payload->Data, sizeof(float) * 3);
    #                 if (const ImGuiPayload* payload = CImGui.AcceptDragDropPayload(IMGUI_PAYLOAD_TYPE_COLOR_4F))
    #                     memcpy((float*)&saved_palette[n], payload->Data, sizeof(float) * 4);
    #                 CImGui.EndDragDropTarget();
    #             }
    #
    #             CImGui.PopID();
    #         }
    #         CImGui.EndGroup();
    #         CImGui.EndPopup();
    #     }
    #
    #     CImGui.Text("Color button only:");
    #     CImGui.ColorButton("MyColor##3c", *(ImVec4*)&color, misc_flags, ImVec2(80,80));
    #
    #     CImGui.Text("Color picker:");
    #     static bool alpha = true;
    #     static bool alpha_bar = true;
    #     static bool side_preview = true;
    #     static bool ref_color = false;
    #     static ImVec4 ref_color_v(1.0f,0.0f,1.0f,0.5f);
    #     static int inputs_mode = 2;
    #     static int picker_mode = 0;
    #     CImGui.Checkbox("With Alpha", &alpha);
    #     CImGui.Checkbox("With Alpha Bar", &alpha_bar);
    #     CImGui.Checkbox("With Side Preview", &side_preview);
    #     if (side_preview)
    #     {
    #         CImGui.SameLine();
    #         CImGui.Checkbox("With Ref Color", &ref_color);
    #         if (ref_color)
    #         {
    #             CImGui.SameLine();
    #             CImGui.ColorEdit4("##RefColor", &ref_color_v.x, ImGuiColorEditFlags_NoInputs | misc_flags);
    #         }
    #     }
    #     CImGui.Combo("Inputs Mode", &inputs_mode, "All Inputs\0No Inputs\0RGB Input\0HSV Input\0HEX Input\0");
    #     CImGui.Combo("Picker Mode", &picker_mode, "Auto/Current\0Hue bar + SV rect\0Hue wheel + SV triangle\0");
    #     CImGui.SameLine(); ShowHelpMarker("User can right-click the picker to change mode.");
    #     ImGuiColorEditFlags flags = misc_flags;
    #     if (!alpha) flags |= ImGuiColorEditFlags_NoAlpha; // This is by default if you call ColorPicker3() instead of ColorPicker4()
    #     if (alpha_bar) flags |= ImGuiColorEditFlags_AlphaBar;
    #     if (!side_preview) flags |= ImGuiColorEditFlags_NoSidePreview;
    #     if (picker_mode == 1) flags |= ImGuiColorEditFlags_PickerHueBar;
    #     if (picker_mode == 2) flags |= ImGuiColorEditFlags_PickerHueWheel;
    #     if (inputs_mode == 1) flags |= ImGuiColorEditFlags_NoInputs;
    #     if (inputs_mode == 2) flags |= ImGuiColorEditFlags_RGB;
    #     if (inputs_mode == 3) flags |= ImGuiColorEditFlags_HSV;
    #     if (inputs_mode == 4) flags |= ImGuiColorEditFlags_HEX;
    #     CImGui.ColorPicker4("MyColor##4", (float*)&color, flags, ref_color ? &ref_color_v.x : NULL);
    #
    #     CImGui.Text("Programmatically set defaults:");
    #     CImGui.SameLine(); ShowHelpMarker("SetColorEditOptions() is designed to allow you to set boot-time default.\nWe don't have Push/Pop functions because you can force options on a per-widget basis if needed, and the user can change non-forced ones with the options menu.\nWe don't have a getter to avoid encouraging you to persistently save values that aren't forward-compatible.");
    #     if (CImGui.Button("Default: Uint8 + HSV + Hue Bar"))
    #         CImGui.SetColorEditOptions(ImGuiColorEditFlags_Uint8 | ImGuiColorEditFlags_HSV | ImGuiColorEditFlags_PickerHueBar);
    #     if (CImGui.Button("Default: Float + HDR + Hue Wheel"))
    #         CImGui.SetColorEditOptions(ImGuiColorEditFlags_Float | ImGuiColorEditFlags_HDR | ImGuiColorEditFlags_PickerHueWheel);
    #
    #     CImGui.TreePop();
    # }

    if CImGui.TreeNode("Range Widgets")
        @cstatic _begin=Cfloat(10) _end=Cfloat(90) begin_i=Cint(100) end_i=Cint(1000) begin
            @c CImGui.DragFloatRange2("range", &_begin, &_end, 0.25, 0.0, 100.0, "Min: %.1f %%", "Max: %.1f %%")
            @c CImGui.DragIntRange2("range int (no bounds)", &begin_i, &end_i, 5, 0, 0, "Min: %d units", "Max: %d units")
        end
        CImGui.TreePop()
    end

    # if (CImGui.TreeNode("Data Types"))
    # {
    #     // The DragScalar/InputScalar/SliderScalar functions allow various data types: signed/unsigned int/long long and float/double
    #     // To avoid polluting the public API with all possible combinations, we use the ImGuiDataType enum to pass the type,
    #     // and passing all arguments by address.
    #     // This is the reason the test code below creates local variables to hold "zero" "one" etc. for each types.
    #     // In practice, if you frequently use a given type that is not covered by the normal API entry points, you can wrap it
    #     // yourself inside a 1 line function which can take typed argument as value instead of void*, and then pass their address
    #     // to the generic function. For example:
    #     //   bool MySliderU64(const char *label, u64* value, u64 min = 0, u64 max = 0, const char* format = "%lld")
    #     //   {
    #     //      return SliderScalar(label, ImGuiDataType_U64, value, &min, &max, format);
    #     //   }
    #
    #     // Limits (as helper variables that we can take the address of)
    #     // Note that the SliderScalar function has a maximum usable range of half the natural type maximum, hence the /2 below.
    #     #ifndef LLONG_MIN
    #     ImS64 LLONG_MIN = -9223372036854775807LL - 1;
    #     ImS64 LLONG_MAX = 9223372036854775807LL;
    #     ImU64 ULLONG_MAX = (2ULL * 9223372036854775807LL + 1);
    #     #endif
    #     const ImS32   s32_zero = 0,   s32_one = 1,   s32_fifty = 50, s32_min = INT_MIN/2,   s32_max = INT_MAX/2,    s32_hi_a = INT_MAX/2 - 100,    s32_hi_b = INT_MAX/2;
    #     const ImU32   u32_zero = 0,   u32_one = 1,   u32_fifty = 50, u32_min = 0,           u32_max = UINT_MAX/2,   u32_hi_a = UINT_MAX/2 - 100,   u32_hi_b = UINT_MAX/2;
    #     const ImS64   s64_zero = 0,   s64_one = 1,   s64_fifty = 50, s64_min = LLONG_MIN/2, s64_max = LLONG_MAX/2,  s64_hi_a = LLONG_MAX/2 - 100,  s64_hi_b = LLONG_MAX/2;
    #     const ImU64   u64_zero = 0,   u64_one = 1,   u64_fifty = 50, u64_min = 0,           u64_max = ULLONG_MAX/2, u64_hi_a = ULLONG_MAX/2 - 100, u64_hi_b = ULLONG_MAX/2;
    #     const float   f32_zero = 0.f, f32_one = 1.f, f32_lo_a = -10000000000.0f, f32_hi_a = +10000000000.0f;
    #     const double  f64_zero = 0.,  f64_one = 1.,  f64_lo_a = -1000000000000000.0, f64_hi_a = +1000000000000000.0;
    #
    #     // State
    #     static ImS32  s32_v = -1;
    #     static ImU32  u32_v = (ImU32)-1;
    #     static ImS64  s64_v = -1;
    #     static ImU64  u64_v = (ImU64)-1;
    #     static float  f32_v = 0.123f;
    #     static double f64_v = 90000.01234567890123456789;
    #
    #     const float drag_speed = 0.2f;
    #     static bool drag_clamp = false;
    #     CImGui.Text("Drags:");
    #     CImGui.Checkbox("Clamp integers to 0..50", &drag_clamp); CImGui.SameLine(); ShowHelpMarker("As with every widgets in dear imgui, we never modify values unless there is a user interaction.\nYou can override the clamping limits by using CTRL+Click to input a value.");
    #     CImGui.DragScalar("drag s32",       ImGuiDataType_S32,    &s32_v, drag_speed, drag_clamp ? &s32_zero : NULL, drag_clamp ? &s32_fifty : NULL);
    #     CImGui.DragScalar("drag u32",       ImGuiDataType_U32,    &u32_v, drag_speed, drag_clamp ? &u32_zero : NULL, drag_clamp ? &u32_fifty : NULL, "%u ms");
    #     CImGui.DragScalar("drag s64",       ImGuiDataType_S64,    &s64_v, drag_speed, drag_clamp ? &s64_zero : NULL, drag_clamp ? &s64_fifty : NULL);
    #     CImGui.DragScalar("drag u64",       ImGuiDataType_U64,    &u64_v, drag_speed, drag_clamp ? &u64_zero : NULL, drag_clamp ? &u64_fifty : NULL);
    #     CImGui.DragScalar("drag float",     ImGuiDataType_Float,  &f32_v, 0.005f,  &f32_zero, &f32_one, "%f", 1.0f);
    #     CImGui.DragScalar("drag float ^2",  ImGuiDataType_Float,  &f32_v, 0.005f,  &f32_zero, &f32_one, "%f", 2.0f); CImGui.SameLine(); ShowHelpMarker("You can use the 'power' parameter to increase tweaking precision on one side of the range.");
    #     CImGui.DragScalar("drag double",    ImGuiDataType_Double, &f64_v, 0.0005f, &f64_zero, NULL,     "%.10f grams", 1.0f);
    #     CImGui.DragScalar("drag double ^2", ImGuiDataType_Double, &f64_v, 0.0005f, &f64_zero, &f64_one, "0 < %.10f < 1", 2.0f);
    #
    #     CImGui.Text("Sliders");
    #     CImGui.SliderScalar("slider s32 low",     ImGuiDataType_S32,    &s32_v, &s32_zero, &s32_fifty,"%d");
    #     CImGui.SliderScalar("slider s32 high",    ImGuiDataType_S32,    &s32_v, &s32_hi_a, &s32_hi_b, "%d");
    #     CImGui.SliderScalar("slider s32 full",    ImGuiDataType_S32,    &s32_v, &s32_min,  &s32_max,  "%d");
    #     CImGui.SliderScalar("slider u32 low",     ImGuiDataType_U32,    &u32_v, &u32_zero, &u32_fifty,"%u");
    #     CImGui.SliderScalar("slider u32 high",    ImGuiDataType_U32,    &u32_v, &u32_hi_a, &u32_hi_b, "%u");
    #     CImGui.SliderScalar("slider u32 full",    ImGuiDataType_U32,    &u32_v, &u32_min,  &u32_max,  "%u");
    #     CImGui.SliderScalar("slider s64 low",     ImGuiDataType_S64,    &s64_v, &s64_zero, &s64_fifty,"%I64d");
    #     CImGui.SliderScalar("slider s64 high",    ImGuiDataType_S64,    &s64_v, &s64_hi_a, &s64_hi_b, "%I64d");
    #     CImGui.SliderScalar("slider s64 full",    ImGuiDataType_S64,    &s64_v, &s64_min,  &s64_max,  "%I64d");
    #     CImGui.SliderScalar("slider u64 low",     ImGuiDataType_U64,    &u64_v, &u64_zero, &u64_fifty,"%I64u ms");
    #     CImGui.SliderScalar("slider u64 high",    ImGuiDataType_U64,    &u64_v, &u64_hi_a, &u64_hi_b, "%I64u ms");
    #     CImGui.SliderScalar("slider u64 full",    ImGuiDataType_U64,    &u64_v, &u64_min,  &u64_max,  "%I64u ms");
    #     CImGui.SliderScalar("slider float low",   ImGuiDataType_Float,  &f32_v, &f32_zero, &f32_one);
    #     CImGui.SliderScalar("slider float low^2", ImGuiDataType_Float,  &f32_v, &f32_zero, &f32_one,  "%.10f", 2.0f);
    #     CImGui.SliderScalar("slider float high",  ImGuiDataType_Float,  &f32_v, &f32_lo_a, &f32_hi_a, "%e");
    #     CImGui.SliderScalar("slider double low",  ImGuiDataType_Double, &f64_v, &f64_zero, &f64_one,  "%.10f grams", 1.0f);
    #     CImGui.SliderScalar("slider double low^2",ImGuiDataType_Double, &f64_v, &f64_zero, &f64_one,  "%.10f", 2.0f);
    #     CImGui.SliderScalar("slider double high", ImGuiDataType_Double, &f64_v, &f64_lo_a, &f64_hi_a, "%e grams", 1.0f);
    #
    #     static bool inputs_step = true;
    #     CImGui.Text("Inputs");
    #     CImGui.Checkbox("Show step buttons", &inputs_step);
    #     CImGui.InputScalar("input s32",     ImGuiDataType_S32,    &s32_v, inputs_step ? &s32_one : NULL, NULL, "%d");
    #     CImGui.InputScalar("input s32 hex", ImGuiDataType_S32,    &s32_v, inputs_step ? &s32_one : NULL, NULL, "%08X", ImGuiInputTextFlags_CharsHexadecimal);
    #     CImGui.InputScalar("input u32",     ImGuiDataType_U32,    &u32_v, inputs_step ? &u32_one : NULL, NULL, "%u");
    #     CImGui.InputScalar("input u32 hex", ImGuiDataType_U32,    &u32_v, inputs_step ? &u32_one : NULL, NULL, "%08X", ImGuiInputTextFlags_CharsHexadecimal);
    #     CImGui.InputScalar("input s64",     ImGuiDataType_S64,    &s64_v, inputs_step ? &s64_one : NULL);
    #     CImGui.InputScalar("input u64",     ImGuiDataType_U64,    &u64_v, inputs_step ? &u64_one : NULL);
    #     CImGui.InputScalar("input float",   ImGuiDataType_Float,  &f32_v, inputs_step ? &f32_one : NULL);
    #     CImGui.InputScalar("input double",  ImGuiDataType_Double, &f64_v, inputs_step ? &f64_one : NULL);
    #
    #     CImGui.TreePop();
    # }
    #
    if CImGui.TreeNode("Multi-component Widgets")
        @cstatic vec4f=Cfloat[0.10, 0.20, 0.30, 0.44] vec4i=Cint[1, 5, 100, 255] begin
            CImGui.InputFloat2("input float2", vec4f)
            CImGui.DragFloat2("drag float2", vec4f, 0.01, 0.0, 1.0)
            CImGui.SliderFloat2("slider float2", vec4f, 0.0, 1.0)
            CImGui.InputInt2("input int2", vec4i)
            CImGui.DragInt2("drag int2", vec4i, 1, 0, 255)
            CImGui.SliderInt2("slider int2", vec4i, 0, 255)
            CImGui.Spacing()

            CImGui.InputFloat3("input float3", vec4f)
            CImGui.DragFloat3("drag float3", vec4f, 0.01, 0.0, 1.0)
            CImGui.SliderFloat3("slider float3", vec4f, 0.0, 1.0)
            CImGui.InputInt3("input int3", vec4i)
            CImGui.DragInt3("drag int3", vec4i, 1, 0, 255)
            CImGui.SliderInt3("slider int3", vec4i, 0, 255)
            CImGui.Spacing()

            CImGui.InputFloat4("input float4", vec4f)
            CImGui.DragFloat4("drag float4", vec4f, 0.01, 0.0, 1.0)
            CImGui.SliderFloat4("slider float4", vec4f, 0.0, 1.0)
            CImGui.InputInt4("input int4", vec4i)
            CImGui.DragInt4("drag int4", vec4i, 1, 0, 255)
            CImGui.SliderInt4("slider int4", vec4i, 0, 255)
        end
        CImGui.TreePop()
    end

    # if (CImGui.TreeNode("Vertical Sliders"))
    # {
    #     const float spacing = 4;
    #     CImGui.PushStyleVar(ImGuiStyleVar_ItemSpacing, ImVec2(spacing, spacing));
    #
    #     static int int_value = 0;
    #     CImGui.VSliderInt("##int", ImVec2(18,160), &int_value, 0, 5);
    #     CImGui.SameLine();
    #
    #     static float values[7] = { 0.0f, 0.60f, 0.35f, 0.9f, 0.70f, 0.20f, 0.0f };
    #     CImGui.PushID("set1");
    #     for (int i = 0; i < 7; i++)
    #     {
    #         if (i > 0) CImGui.SameLine();
    #         CImGui.PushID(i);
    #         CImGui.PushStyleColor(ImGuiCol_FrameBg, (ImVec4)ImColor::HSV(i/7.0f, 0.5f, 0.5f));
    #         CImGui.PushStyleColor(ImGuiCol_FrameBgHovered, (ImVec4)ImColor::HSV(i/7.0f, 0.6f, 0.5f));
    #         CImGui.PushStyleColor(ImGuiCol_FrameBgActive, (ImVec4)ImColor::HSV(i/7.0f, 0.7f, 0.5f));
    #         CImGui.PushStyleColor(ImGuiCol_SliderGrab, (ImVec4)ImColor::HSV(i/7.0f, 0.9f, 0.9f));
    #         CImGui.VSliderFloat("##v", ImVec2(18,160), &values[i], 0.0f, 1.0f, "");
    #         if (CImGui.IsItemActive() || CImGui.IsItemHovered())
    #             CImGui.SetTooltip("%.3f", values[i]);
    #         CImGui.PopStyleColor(4);
    #         CImGui.PopID();
    #     }
    #     CImGui.PopID();
    #
    #     CImGui.SameLine();
    #     CImGui.PushID("set2");
    #     static float values2[4] = { 0.20f, 0.80f, 0.40f, 0.25f };
    #     const int rows = 3;
    #     const ImVec2 small_slider_size(18, (160.0f-(rows-1)*spacing)/rows);
    #     for (int nx = 0; nx < 4; nx++)
    #     {
    #         if (nx > 0) CImGui.SameLine();
    #         CImGui.BeginGroup();
    #         for (int ny = 0; ny < rows; ny++)
    #         {
    #             CImGui.PushID(nx*rows+ny);
    #             CImGui.VSliderFloat("##v", small_slider_size, &values2[nx], 0.0f, 1.0f, "");
    #             if (CImGui.IsItemActive() || CImGui.IsItemHovered())
    #                 CImGui.SetTooltip("%.3f", values2[nx]);
    #             CImGui.PopID();
    #         }
    #         CImGui.EndGroup();
    #     }
    #     CImGui.PopID();
    #
    #     CImGui.SameLine();
    #     CImGui.PushID("set3");
    #     for (int i = 0; i < 4; i++)
    #     {
    #         if (i > 0) CImGui.SameLine();
    #         CImGui.PushID(i);
    #         CImGui.PushStyleVar(ImGuiStyleVar_GrabMinSize, 40);
    #         CImGui.VSliderFloat("##v", ImVec2(40,160), &values[i], 0.0f, 1.0f, "%.2f\nsec");
    #         CImGui.PopStyleVar();
    #         CImGui.PopID();
    #     }
    #     CImGui.PopID();
    #     CImGui.PopStyleVar();
    #     CImGui.TreePop();
    # }
    #
    # if (CImGui.TreeNode("Drag and Drop"))
    # {
    #     {
    #         // ColorEdit widgets automatically act as drag source and drag target.
    #         // They are using standardized payload strings IMGUI_PAYLOAD_TYPE_COLOR_3F and IMGUI_PAYLOAD_TYPE_COLOR_4F to allow your own widgets
    #         // to use colors in their drag and drop interaction. Also see the demo in Color Picker -> Palette demo.
    #         CImGui.BulletText("Drag and drop in standard widgets");
    #         CImGui.Indent();
    #         static float col1[3] = { 1.0f,0.0f,0.2f };
    #         static float col2[4] = { 0.4f,0.7f,0.0f,0.5f };
    #         CImGui.ColorEdit3("color 1", col1);
    #         CImGui.ColorEdit4("color 2", col2);
    #         CImGui.Unindent();
    #     }
    #
    #     {
    #         CImGui.BulletText("Drag and drop to copy/swap items");
    #         CImGui.Indent();
    #         enum Mode
    #         {
    #             Mode_Copy,
    #             Mode_Move,
    #             Mode_Swap
    #         };
    #         static int mode = 0;
    #         if (CImGui.RadioButton("Copy", mode == Mode_Copy)) { mode = Mode_Copy; } CImGui.SameLine();
    #         if (CImGui.RadioButton("Move", mode == Mode_Move)) { mode = Mode_Move; } CImGui.SameLine();
    #         if (CImGui.RadioButton("Swap", mode == Mode_Swap)) { mode = Mode_Swap; }
    #         static const char* names[9] = { "Bobby", "Beatrice", "Betty", "Brianna", "Barry", "Bernard", "Bibi", "Blaine", "Bryn" };
    #         for (int n = 0; n < IM_ARRAYSIZE(names); n++)
    #         {
    #             CImGui.PushID(n);
    #             if ((n % 3) != 0)
    #                 CImGui.SameLine();
    #             CImGui.Button(names[n], ImVec2(60,60));
    #
    #             // Our buttons are both drag sources and drag targets here!
    #             if (CImGui.BeginDragDropSource(ImGuiDragDropFlags_None))
    #             {
    #                 CImGui.SetDragDropPayload("DND_DEMO_CELL", &n, sizeof(int));        // Set payload to carry the index of our item (could be anything)
    #                 if (mode == Mode_Copy) { CImGui.Text("Copy %s", names[n]); }        // Display preview (could be anything, e.g. when dragging an image we could decide to display the filename and a small preview of the image, etc.)
    #                 if (mode == Mode_Move) { CImGui.Text("Move %s", names[n]); }
    #                 if (mode == Mode_Swap) { CImGui.Text("Swap %s", names[n]); }
    #                 CImGui.EndDragDropSource();
    #             }
    #             if (CImGui.BeginDragDropTarget())
    #             {
    #                 if (const ImGuiPayload* payload = CImGui.AcceptDragDropPayload("DND_DEMO_CELL"))
    #                 {
    #                     IM_ASSERT(payload->DataSize == sizeof(int));
    #                     int payload_n = *(const int*)payload->Data;
    #                     if (mode == Mode_Copy)
    #                     {
    #                         names[n] = names[payload_n];
    #                     }
    #                     if (mode == Mode_Move)
    #                     {
    #                         names[n] = names[payload_n];
    #                         names[payload_n] = "";
    #                     }
    #                     if (mode == Mode_Swap)
    #                     {
    #                         const char* tmp = names[n];
    #                         names[n] = names[payload_n];
    #                         names[payload_n] = tmp;
    #                     }
    #                 }
    #                 CImGui.EndDragDropTarget();
    #             }
    #             CImGui.PopID();
    #         }
    #         CImGui.Unindent();
    #     }
    #
    #     CImGui.TreePop();
    # }
    #
    # if (CImGui.TreeNode("Querying Status (Active/Focused/Hovered etc.)"))
    # {
    #     // Display the value of IsItemHovered() and other common item state functions. Note that the flags can be combined.
    #     // (because BulletText is an item itself and that would affect the output of IsItemHovered() we pass all state in a single call to simplify the code).
    #     static int item_type = 1;
    #     static bool b = false;
    #     static float col4f[4] = { 1.0f, 0.5, 0.0f, 1.0f };
    #     CImGui.RadioButton("Text", &item_type, 0);
    #     CImGui.RadioButton("Button", &item_type, 1);
    #     CImGui.RadioButton("Checkbox", &item_type, 2);
    #     CImGui.RadioButton("SliderFloat", &item_type, 3);
    #     CImGui.RadioButton("ColorEdit4", &item_type, 4);
    #     CImGui.RadioButton("ListBox", &item_type, 5);
    #     CImGui.Separator();
    #     bool ret = false;
    #     if (item_type == 0) { CImGui.Text("ITEM: Text"); }                                              // Testing text items with no identifier/interaction
    #     if (item_type == 1) { ret = CImGui.Button("ITEM: Button"); }                                    // Testing button
    #     if (item_type == 2) { ret = CImGui.Checkbox("ITEM: Checkbox", &b); }                            // Testing checkbox
    #     if (item_type == 3) { ret = CImGui.SliderFloat("ITEM: SliderFloat", &col4f[0], 0.0f, 1.0f); }   // Testing basic item
    #     if (item_type == 4) { ret = CImGui.ColorEdit4("ITEM: ColorEdit4", col4f); }                     // Testing multi-component items (IsItemXXX flags are reported merged)
    #     if (item_type == 5) { const char* items[] = { "Apple", "Banana", "Cherry", "Kiwi" }; static int current = 1; ret = CImGui.ListBox("ITEM: ListBox", &current, items, IM_ARRAYSIZE(items), IM_ARRAYSIZE(items)); }
    #     CImGui.BulletText(
    #         "Return value = %d\n"
    #         "IsItemFocused() = %d\n"
    #         "IsItemHovered() = %d\n"
    #         "IsItemHovered(_AllowWhenBlockedByPopup) = %d\n"
    #         "IsItemHovered(_AllowWhenBlockedByActiveItem) = %d\n"
    #         "IsItemHovered(_AllowWhenOverlapped) = %d\n"
    #         "IsItemHovered(_RectOnly) = %d\n"
    #         "IsItemActive() = %d\n"
    #         "IsItemEdited() = %d\n"
    #         "IsItemActivated() = %d\n"
    #         "IsItemDeactivated() = %d\n"
    #         "IsItemDeactivatedEdit() = %d\n"
    #         "IsItemVisible() = %d\n"
    #         "GetItemRectMin() = (%.1f, %.1f)\n"
    #         "GetItemRectMax() = (%.1f, %.1f)\n"
    #         "GetItemRectSize() = (%.1f, %.1f)",
    #         ret,
    #         CImGui.IsItemFocused(),
    #         CImGui.IsItemHovered(),
    #         CImGui.IsItemHovered(ImGuiHoveredFlags_AllowWhenBlockedByPopup),
    #         CImGui.IsItemHovered(ImGuiHoveredFlags_AllowWhenBlockedByActiveItem),
    #         CImGui.IsItemHovered(ImGuiHoveredFlags_AllowWhenOverlapped),
    #         CImGui.IsItemHovered(ImGuiHoveredFlags_RectOnly),
    #         CImGui.IsItemActive(),
    #         CImGui.IsItemEdited(),
    #         CImGui.IsItemActivated(),
    #         CImGui.IsItemDeactivated(),
    #         CImGui.IsItemDeactivatedAfterEdit(),
    #         CImGui.IsItemVisible(),
    #         CImGui.GetItemRectMin().x, CImGui.GetItemRectMin().y,
    #         CImGui.GetItemRectMax().x, CImGui.GetItemRectMax().y,
    #         CImGui.GetItemRectSize().x, CImGui.GetItemRectSize().y
    #     );
    #
    #     static bool embed_all_inside_a_child_window = false;
    #     CImGui.Checkbox("Embed everything inside a child window (for additional testing)", &embed_all_inside_a_child_window);
    #     if (embed_all_inside_a_child_window)
    #         CImGui.BeginChild("outer_child", ImVec2(0, CImGui.GetFontSize() * 20), true);
    #
    #     // Testing IsWindowFocused() function with its various flags. Note that the flags can be combined.
    #     CImGui.BulletText(
    #         "IsWindowFocused() = %d\n"
    #         "IsWindowFocused(_ChildWindows) = %d\n"
    #         "IsWindowFocused(_ChildWindows|_RootWindow) = %d\n"
    #         "IsWindowFocused(_RootWindow) = %d\n"
    #         "IsWindowFocused(_AnyWindow) = %d\n",
    #         CImGui.IsWindowFocused(),
    #         CImGui.IsWindowFocused(ImGuiFocusedFlags_ChildWindows),
    #         CImGui.IsWindowFocused(ImGuiFocusedFlags_ChildWindows | ImGuiFocusedFlags_RootWindow),
    #         CImGui.IsWindowFocused(ImGuiFocusedFlags_RootWindow),
    #         CImGui.IsWindowFocused(ImGuiFocusedFlags_AnyWindow));
    #
    #     // Testing IsWindowHovered() function with its various flags. Note that the flags can be combined.
    #     CImGui.BulletText(
    #         "IsWindowHovered() = %d\n"
    #         "IsWindowHovered(_AllowWhenBlockedByPopup) = %d\n"
    #         "IsWindowHovered(_AllowWhenBlockedByActiveItem) = %d\n"
    #         "IsWindowHovered(_ChildWindows) = %d\n"
    #         "IsWindowHovered(_ChildWindows|_RootWindow) = %d\n"
    #         "IsWindowHovered(_RootWindow) = %d\n"
    #         "IsWindowHovered(_AnyWindow) = %d\n",
    #         CImGui.IsWindowHovered(),
    #         CImGui.IsWindowHovered(ImGuiHoveredFlags_AllowWhenBlockedByPopup),
    #         CImGui.IsWindowHovered(ImGuiHoveredFlags_AllowWhenBlockedByActiveItem),
    #         CImGui.IsWindowHovered(ImGuiHoveredFlags_ChildWindows),
    #         CImGui.IsWindowHovered(ImGuiHoveredFlags_ChildWindows | ImGuiHoveredFlags_RootWindow),
    #         CImGui.IsWindowHovered(ImGuiHoveredFlags_RootWindow),
    #         CImGui.IsWindowHovered(ImGuiHoveredFlags_AnyWindow));
    #
    #     CImGui.BeginChild("child", ImVec2(0, 50), true);
    #     CImGui.Text("This is another child window for testing the _ChildWindows flag.");
    #     CImGui.EndChild();
    #     if (embed_all_inside_a_child_window)
    #         CImGui.EndChild();
    #
    #     // Calling IsItemHovered() after begin returns the hovered status of the title bar.
    #     // This is useful in particular if you want to create a context menu (with BeginPopupContextItem) associated to the title bar of a window.
    #     static bool test_window = false;
    #     CImGui.Checkbox("Hovered/Active tests after Begin() for title bar testing", &test_window);
    #     if (test_window)
    #     {
    #         CImGui.Begin("Title bar Hovered/Active tests", &test_window);
    #         if (CImGui.BeginPopupContextItem()) // <-- This is using IsItemHovered()
    #         {
    #             if (CImGui.MenuItem("Close")) { test_window = false; }
    #             CImGui.EndPopup();
    #         }
    #         CImGui.Text(
    #             "IsItemHovered() after begin = %d (== is title bar hovered)\n"
    #             "IsItemActive() after begin = %d (== is window being clicked/moved)\n",
    #             CImGui.IsItemHovered(), CImGui.IsItemActive());
    #         CImGui.End();
    #     }
    #
    #     CImGui.TreePop();
    # }
end
